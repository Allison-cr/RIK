//
//  StatisticsLogic.swift
//  RIK
//
//  Created by Alexander Suprun on 19.09.2024.
//

import RxSwift
import DGCharts
import Foundation
//import LoadManager

final class StatisticsLogic {
    private let disposeBag = DisposeBag()
       
       func fetchStatisticsData() -> Observable<([ChartDataEntry], Int, Int)> {
           let viewDataObservable = fetchViewData()
           let subscriptionCountObservable = fetchSubscriptionCount()
           let unsubscriptionCountObservable = fetchUnsubscriptionCount()
           return Observable.combineLatest(viewDataObservable, subscriptionCountObservable, unsubscriptionCountObservable)
       }

    func fetchUsersData() -> Observable<([Users], [String: (Int, Int)], (Int, Int))> {
        let usersObservable = fetchUsers()
        
        let usersToChartDataObservable = usersObservable.map { users in
            return self.transformUsersToChartData(users: users)
        }
        
        let mwStatsObservable = usersObservable.map { users in
            return self.transformMWStatistic(users: users)
        }
        
        return Observable.combineLatest(usersObservable, usersToChartDataObservable, mwStatsObservable)
    }
}

// default loadgin dont change
extension StatisticsLogic {
    private func fetchStatistics() -> Observable<[Statistic]> {
        let realmStatistics = fetchStatisticsFromRealm()
        
        if !realmStatistics.isEmpty {
            print("Fetched from Realm")
            return Observable.just(realmStatistics)
        } else {
            return fetchData(from: "https://cars.cprogroup.ru/api/episode/statistics/", decodeType: StatisticsResponse.self)
                .do(onNext: { [weak self] response in
                    print("Fetched from API: \(response)")
                    self?.saveStatisticsToRealm(statistics: response.statistics)
                })
                .map { $0.statistics }
                .catch { error in
                    print("Error fetching statistics: \(error)")
                    return Observable.just([]) // Вернуть пустой массив в случае ошибки
                }
        }
    }
    
    
    private func fetchUsers() -> Observable<[Users]> {
        let realmUsers = fetchUsersFromRealm()
        
        if !realmUsers.isEmpty {
            print("Fetched from Realm")
            return Observable.just(realmUsers)
        } else {
            return fetchData(from: "https://cars.cprogroup.ru/api/episode/users/", decodeType: UsersResponse.self)
                .do(onNext: { [weak self] response in
                    print("Fetched from API: \(response)")
                    self?.saveUsersToRealm(users: response.users)
                })
                .map { $0.users }
                .catch { error in
                    print("Error fetching users: \(error)")
                    return Observable.just([])
                }
        }
    }

    
    private func fetchData<T: Decodable>(from urlString: String, decodeType: T.Type) -> Observable<T> {
        return Observable.create { observer in
            guard let url = URL(string: urlString) else {
                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: data)
                    print(decodedData)
                    observer.onNext(decodedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
// methods for the distribution of statistical data
private extension StatisticsLogic {
    private func fetchViewData() -> Observable<[ChartDataEntry]> {
        return fetchStatistics()
            .map { statistics in
                let viewStatistics = statistics.filter { $0.type == TypeData.view.getMessage() }
                return self.transformStatisticsToChartData(statistics: viewStatistics)
            }
    }

    private func fetchSubscriptionCount() -> Observable<Int> {
        return fetchStatistics()
            .map { statistics in
                return statistics.filter { $0.type == TypeData.subscription.getMessage() }.count
            }
    }
    
    private func fetchUnsubscriptionCount() -> Observable<Int> {
        return fetchStatistics()
            .map { statistics in
                return statistics.filter { $0.type == TypeData.unsubscription.getMessage() }.count
            }
    }
    
    private func transformStatisticsToChartData(statistics: [Statistic]) -> [ChartDataEntry] {
        var dateCounts: [Double: Int] = [:]
        
        statistics.forEach { stat in
            stat.dates.forEach { date in
                let dateString = String(date)
                let day = dateString.dropLast(6)
                if dateString.count == 8 {
                    let month = dateString.dropLast(4).dropFirst(2)
                    let formattedDate = Double("\(day).\(month)")
                    dateCounts[formattedDate ?? 0, default: 0] += 1
                } else {
                    let month = dateString.dropLast(4).dropFirst(1)
                    let formattedDate = Double("\(day).\(month)")
                    dateCounts[formattedDate ?? 0, default: 0] += 1
                }
            }
        }
        return dateCounts.map { ChartDataEntry(x: ($0.key), y: Double($0.value)) }.sorted { $0.x < $1.x }
    }
}

extension StatisticsLogic {
    private func transformUsersToChartData(users: [Users]) -> [String: (Int, Int)] {
        var ageGroups: [String: (Int, Int)] = [
            "18-21": (0, 0),
            "22-25": (0, 0),
            "26-30": (0, 0),
            "31-35": (0, 0),
            "36-40": (0, 0),
            "40-50": (0, 0),
            ">50": (0, 0)
        ]
        
        let totalUsers = users.count
        
        for user in users {
            let ageRange: String
            
            switch user.age {
            case 18...21:
                ageRange = "18-21"
            case 22...25:
                ageRange = "22-25"
            case 26...30:
                ageRange = "26-30"
            case 31...35:
                ageRange = "31-35"
            case 36...40:
                ageRange = "36-40"
            case 40...50:
                ageRange = "40-50"
            default:
                ageRange = ">50"
            }
            
            if user.sex == "M" {
                ageGroups[ageRange]?.0 += 1
            } else if user.sex == "W" {
                ageGroups[ageRange]?.1 += 1
            }
        }
        
        return ageGroups.mapValues { (Int(Double($0.0) * 100.0 / Double(totalUsers)), Int(Double($0.1) * 100.0 / Double(totalUsers))) }
    }
    
    private func transformMWStatistic(users: [Users]) -> (Int,Int) {
        var MW = (0, 0)
        users.forEach { users in
            if users.sex == "M" {
                MW.0 += 1
            } else {
                MW.1 += 1
            }
        }
        return MW
    }
}


import RealmSwift

extension StatisticsLogic {
        private func saveStatisticsToRealm(statistics: [Statistic]) {
            let realm = try! Realm()
            try! realm.write {
                for statistic in statistics {
                    let statisticObject = StatisticObject()
                    statisticObject.userId = statistic.userId
                    statisticObject.type = statistic.type
                    statisticObject.dates.append(objectsIn: statistic.dates)
                    statisticObject.generateCompoundKey()
                    realm.add(statisticObject, update: .modified)
                }
            }
    }
    
    private func saveUsersToRealm(users: [Users]) {
        do {
            let realm = try Realm()
            try realm.write {
                for user in users {
                    let userObject = UserObject()
                    userObject.id = user.id
                    userObject.sex = user.sex
                    userObject.username = user.username
                    userObject.isOnline = user.isOnline
                    userObject.age = user.age

                    if let existingUser = realm.object(ofType: UserObject.self, forPrimaryKey: user.id) {
                        existingUser.sex = user.sex
                        existingUser.username = user.username
                        existingUser.isOnline = user.isOnline
                        existingUser.age = user.age

                        for file in user.files {
                            if let existingFile = existingUser.files.first(where: { $0.id == file.id }) {
                                existingFile.url = file.url
                                existingFile.type = file.type
                            } else {
                                let userFile = UserFile()
                                userFile.id = file.id
                                userFile.url = file.url
                                userFile.type = file.type
                                existingUser.files.append(userFile)
                            }
                        }
                    } else {
                        for file in user.files {
                            let userFile = UserFile()
                            userFile.id = file.id
                            userFile.url = file.url
                            userFile.type = file.type
                            userObject.files.append(userFile)
                        }
                        realm.add(userObject, update: .all)
                    }
                }
            }
        } catch {
            print("Ошибка при сохранении пользователей в Realm: \(error)")
        }
    }



    private func fetchUsersFromRealm() -> [Users] {
        do {
            let realm = try Realm()
            let userObjects = realm.objects(UserObject.self)
            return Array(userObjects.map { userObject in
                let files = Array(userObject.files.map { userFile in
                    File(id: userFile.id, url: userFile.url, type: userFile.type)
                })


                return Users(id: userObject.id, sex: userObject.sex, username: userObject.username,
                             isOnline: userObject.isOnline, age: userObject.age, files: files)
            })
        } catch {
            print("Ошибка при получении пользователей из Realm: \(error)")
            return []
        }
    }

    private func fetchStatisticsFromRealm() -> [Statistic] {
        do {
            let realm = try Realm()
            let statisticObjects = realm.objects(StatisticObject.self)
            return statisticObjects.map { Statistic(userId: $0.userId, type: $0.type, dates: $0.dates.map { Int($0) ?? 0 }) }
        } catch {
            print("Error fetching statistics from Realm: \(error)")
            return []
        }
    }

}
