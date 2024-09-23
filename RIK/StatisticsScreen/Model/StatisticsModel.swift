//
//  StatisticsModel.swift
//  RIK
//
//  Created by Alexander Suprun on 18.09.2024.
//

import Foundation
import RealmSwift

struct Statistic: Codable {
    let userId: Int
    let type: String
    let dates: [Int]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case type
        case dates
    }
}

struct StatisticsResponse: Codable {
    let statistics: [Statistic]
}

class StatisticObject: Object {
    @objc dynamic var userId: Int = 0
    @objc dynamic var type: String = ""
    let dates = List<Int>()

    @objc dynamic var compoundKey: String = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    func generateCompoundKey() {
        self.compoundKey = "\(userId)_\(type)"
    }
}
