import UIKit
import PinLayout
import RxSwift
import DGCharts
import RealmSwift

final class StatisticsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let statisticsView = StatisticsView()
    private let service = StatisticsLogic()
    private let disposeBag = DisposeBag()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
           super.viewDidLoad()
            loadData()
           view.addSubview(scrollView)
           scrollView.frame = view.bounds
           scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

           scrollView.addSubview(statisticsView)
           statisticsView.frame.size.width = view.bounds.width
//           statisticsView.layoutIfNeeded()
           scrollView.contentSize = statisticsView.frame.size
        print("vied did load \(statisticsView.frame.size)")
       }


    
    private func loadData() {
        service.fetchStatisticsData()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (chartDataEntries, subscriptionCount, unsubscriptionCount) in
                self?.statisticsView.updateChart(with: chartDataEntries)
                self?.statisticsView.updateSubscription(subscription: subscriptionCount)
                self?.statisticsView.updateUnsubscription(unsubscription: unsubscriptionCount)
                self?.statisticsView.layoutIfNeeded()
                self?.refreshControl.endRefreshing()
            }, onError: { [weak self] error in
                print("Ошибка загрузки данных: \(error.localizedDescription)")
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        service.fetchUsersData()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] usersObservable, usersToChartDataObservable, mwStatsObservable in
                self?.statisticsView.updateDataTable(with: usersObservable)
                self?.statisticsView.updateDataHorizonntalBarStackView(with: usersToChartDataObservable)
                self?.statisticsView.updatePieChart(with: mwStatsObservable)
                self?.statisticsView.layoutIfNeeded()
                self?.refreshControl.endRefreshing()
            }, onError: { [weak self] error in
                print("Ошибка загрузки данных: \(error.localizedDescription)")
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }

}
