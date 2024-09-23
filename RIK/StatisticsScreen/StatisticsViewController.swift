//
//  StatisticsViewController.swift
//  RIK
//
//  Created by Alexander Suprun on 18.09.2024.
//
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
        setupScrollView()
        loadData()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(statisticsView)


        scrollView.pin.all()
        contentView.pin.all()

        statisticsView.pin.top().left().right()
        
        contentView.pin.bottom(to: statisticsView.edge.bottom)
    }

    private func loadData() {
        service.fetchStatisticsData()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (chartDataEntries, subscriptionCount, unsubscriptionCount) in
                self?.statisticsView.updateChart(with: chartDataEntries)
                self?.statisticsView.updateSubscription(subscription: subscriptionCount)
                self?.statisticsView.updateUnsubscription(unsubscription: unsubscriptionCount)
                
                self?.contentView.layoutIfNeeded()
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

                self?.contentView.layoutIfNeeded()
                self?.refreshControl.endRefreshing()
            }, onError: { [weak self] error in
                print("Ошибка загрузки данных: \(error.localizedDescription)")
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}
