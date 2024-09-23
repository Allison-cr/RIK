//
//  StatisticsView.swift
//  RIK
//
//  Created by Alexander Suprun on 18.09.2024.
//
import UIKit
import PinLayout
import Charts
import DGCharts
import RxSwift

final class StatisticsView: UIView, ChartViewDelegate {
    
    var users: [Users] = []
    
    private lazy var headerLabel: UILabel = setupHeaderLabel()
    private lazy var clientsLabel: UILabel = setupClientsLabel()
    private lazy var recentCheckLabel: UILabel = setupRecentCheckLabel()
    private lazy var genderAndAgeLabel: UILabel = setupGenderAndAgeLabel()
    private lazy var observersLabel: UILabel = setupObserversLabel()
    private lazy var dataLabel: UILabel = setupDataLabel()
    private lazy var viewsLabel: UILabel = setupViewsLabel()
    
    private lazy var informationViewVerticalStackView: UIStackView = setupInformationViewVerticalStackView()
    private lazy var viewsHorizontalStackView: UIStackView = setupViewsHorizontalStackView()
    private lazy var genderHorizontalStackView: UIStackView = setupGenderHorizontalStackView()
    private lazy var horizontalBarStackView: UIStackView = setupHorizontalBarStackView()

    private lazy var perDayButton: UIButton = setupButton(withTitle: .day)
    private lazy var perMonthButton: UIButton = setupButton(withTitle: .month)
    private lazy var perWeekButton: UIButton = setupButton(withTitle: .week)
    private lazy var genderPerDayButton: UIButton = setupButton(withTitle: .day)
    private lazy var genderPerWeekButton: UIButton = setupButton(withTitle: .week)
    private lazy var genderPerMonthButton: UIButton = setupButton(withTitle: .month)
    private lazy var genderPerAllButton: UIButton = setupButton(withTitle: .alltime)
    private var viewsSelectedButton: UIButton?
    private var genderSelectedButton: UIButton?
    
    private lazy var separatorView = UIImageView().separator()
    private lazy var separatorForViews = UIImageView().separator()
    lazy var usersTableView: UITableView = setupUsersTableView()
    private lazy var pieChartView: PieChartView = setupPieChartView()
    private lazy var signView: SignView = SignView(state: .up, quantity: 0)
    private lazy var followersView: SignView = SignView(state: .up, quantity: 0)
    private lazy var stopFollowersView: SignView = SignView(state: .down, quantity: 0)
    private lazy var chartView: LineChartView = setupChartView()
    private var genderMView = GenderView(gender: .man)
    private var genderWView = GenderView(gender: .woman)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgound
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.pin
            .top(pin.safeArea.top + 20)
            .left(16)
            .right(16)
            .sizeToFit()
        
        clientsLabel.pin
            .below(of: headerLabel).marginTop(20)
            .left(16)
            .sizeToFit()
        
        signView.pin
            .below(of: clientsLabel).marginTop(20)
            .left(16)
            .right(16)
            .width(signView.intrinsicContentSize.width)
            .height(signView.intrinsicContentSize.height)

        
        viewsHorizontalStackView.pin
            .below(of: signView).marginTop(20)
            .left(16)
            .sizeToFit(.height)
        
        
        chartView.pin
            .below(of: viewsHorizontalStackView).marginTop(20)
            .left(16)
            .right(16)
            .height(12%)
        
        recentCheckLabel.pin
            .below(of: chartView).marginTop(20)
            .left(20)
            .sizeToFit()
        
        usersTableView.pin
            .below(of: recentCheckLabel).marginTop(20)
            .left(16)
            .right(16)
            .height(62*3)

        genderAndAgeLabel.pin
            .below(of: usersTableView).marginTop(20)
            .left(16)
            .sizeToFit()
        
        genderHorizontalStackView.pin
            .below(of: genderAndAgeLabel).marginTop(20)
            .left(16)
            .sizeToFit()
        
        pieChartView.pin
            .below(of: genderHorizontalStackView).marginTop(20)
            .left(16)
            .right(16)
            .height(228)
        
        genderWView.pin
            .bottomRight(to: pieChartView.anchor.bottomRight).marginRight(16)
            .width(genderWView.intrinsicContentSize.width)
            .height(genderWView.intrinsicContentSize.height)
        
        genderMView.pin
            .bottomLeft(to: pieChartView.anchor.bottomLeft).marginLeft(16)
            .width(genderMView.intrinsicContentSize.width)
            .height(genderMView.intrinsicContentSize.height)
        
        separatorView.pin
            .below(of: genderMView)
            .left(16)
            .right(16)
            .height(0.5)
            
        horizontalBarStackView.pin
            .below(of: separatorView)
            .left(16)
            .right(16)
            .sizeToFit(.width)
        
        observersLabel.pin
            .below(of: horizontalBarStackView).marginTop(28)
            .left(16)
            .right(16)
            .sizeToFit()
        
        followersView.pin
            .below(of: observersLabel).marginTop(12)
            .left(16)
            .right(16)
            .height(followersView.intrinsicContentSize.height)
        
        separatorForViews.pin
            .below(of: followersView)
            .left(16)
            .right(16)
            .height(0.5)

        stopFollowersView.pin
            .below(of: separatorForViews)
            .left(16)
            .right(16)
            .height(stopFollowersView.intrinsicContentSize.height)
    }


}

// MARK: action for chart
extension StatisticsView {
    // bag layoput memory
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        DispatchQueue.main.async {
//            self.dataLabel.text = "\(entry.y) посетитель"
//            self.viewsLabel.text = "\(entry.x) месяц"
//            self.informationViewVerticalStackView.isHidden = false
//            
           
//            self.informationViewVerticalStackView.pin
//                .top(to: chartView.edge.top).marginTop(8)
//                .left(highlight.xPx)
//            self.informationViewVerticalStackView.setNeedsLayout()

        }
    }
}

// MARK: Methods for update binds
extension StatisticsView {
    
    func updatePieChart(with stats: (Int, Int)) {
        let entries = [PieChartDataEntry(value: Double(stats.1), label: "Мужчины"),
                       PieChartDataEntry(value: Double(stats.0), label: "Женщины")]
        
        let dataSet = PieChartDataSet(entries: entries, label: "")

        dataSet.colors = [UIColor(resource: .man),
                          UIColor(resource: .women)]
        
        dataSet.sliceSpace = 2
        
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
 
    }
    
    func updateDataHorizonntalBarStackView(with data: [String: (Int, Int)]) {
        horizontalBarStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let sortedData = data.sorted(by: { $0.key < $1.key })
        
        for (key, values) in sortedData {
            let chartView = CustomHorizontalBarChartView(ageGroup: key, menPercentage: values.0, womenPercentage: values.1)
            
            horizontalBarStackView.addArrangedSubview(chartView)
        }
    }

    func updateChart(with data: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: data, label: "Data")
        dataSet.colors = [.red]
        dataSet.circleColors = [.red]
        dataSet.circleRadius = 8
        dataSet.lineWidth = 4
        
        dataSet.drawValuesEnabled = false
        
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.highlightLineDashLengths = [5, 2.5]
        dataSet.highlightLineWidth = 2
        dataSet.highlightColor = .red
            
        
        chartView.leftAxis.axisMinimum = -dataSet.yMin
        chartView.leftAxis.axisMaximum = dataSet.yMax * 2
        
        
        let line1 = ChartLimitLine(limit: -dataSet.yMin)
        line1.lineWidth = 1
        line1.lineDashLengths = [10, 5]
        line1.lineColor = .graph
        
        let line2 = ChartLimitLine(limit: dataSet.yMax * 1.5)
        line2.lineWidth = 1
        line2.lineDashLengths = [10, 5]
        line2.lineColor = .graph

        
        let line3 = ChartLimitLine(limit: 3)
        line3.lineWidth = 1
        line3.lineDashLengths = [10, 5]
        line3.lineColor = .graph

        
        chartView.leftAxis.addLimitLine(line1)
        chartView.leftAxis.addLimitLine(line2)
        chartView.leftAxis.addLimitLine(line3)
        chartView.notifyDataSetChanged()
        
        let xValues = data.map { $0.x }

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawLabelsEnabled = true

        chartView.notifyDataSetChanged()
        let chartData = LineChartData(dataSet: dataSet)
        chartView.data = chartData
    }
   
    func updateDataTable(with users: [Users]) {
        self.users = users
        usersTableView.reloadData()
    }
}

// MARK: Update Labels
extension StatisticsView {
    func updateSubscription(subscription: Int) {
        signView.quantity = subscription
        followersView.quantity = subscription
    }
    
    func updateUnsubscription(unsubscription: Int) {
        stopFollowersView.quantity = unsubscription
    }
}

// MARK: Setup UI
private extension StatisticsView {
    func setupUI() {
        setupViewHierarchy()
        setupButtonActions()
        setupGenderButtons()
        chartView.delegate = self
    }
}

// MARK: Setup View Hierarchy and Layout
private extension StatisticsView {
    func setupViewHierarchy() {
        addSubview(headerLabel)
        addSubview(clientsLabel)
        addSubview(signView)
        addSubview(viewsHorizontalStackView)
        addSubview(chartView)
        addSubview(usersTableView)
        addSubview(informationViewVerticalStackView)
        addSubview(genderHorizontalStackView)
        addSubview(pieChartView)
        addSubview(recentCheckLabel)
        addSubview(genderAndAgeLabel)
        addSubview(genderMView)
        addSubview(genderWView)
        addSubview(separatorView)
        addSubview(horizontalBarStackView)
        addSubview(observersLabel)
        addSubview(followersView)
        addSubview(separatorForViews)
        addSubview(stopFollowersView)
    }
}


// MARK: SetupUI
private extension StatisticsView {
    
    func setupPieChartView() -> PieChartView {
        let chartView = PieChartView(frame: .zero)
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
    
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.extraBottomOffset = 20
        chartView.legend.enabled = false
        chartView.drawEntryLabelsEnabled = false
        chartView.holeRadiusPercent = 0.5
        chartView.transparentCircleRadiusPercent = 0.55
        chartView.holeColor = .white
        chartView.drawCenterTextEnabled = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .white
        return chartView
        
    }

    func setupHorizontalBarChart() -> HorizontalBarChartView {
        let barChartView = HorizontalBarChartView()
        
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false

        barChartView.backgroundColor = .white
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        return barChartView
    }

    func setupHorizontalBarStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }
    
    func setupChartView() -> LineChartView {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = true
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false

        chartView.leftAxis.enabled = true
        chartView.legend.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.backgroundColor = .white
        chartView.layer.cornerRadius = 16
        chartView.layer.masksToBounds = true
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.extraLeftOffset = 20
        chartView.extraRightOffset = 20
        chartView.extraTopOffset = 20
        chartView.extraBottomOffset = 20
        return chartView
    }
    
    func setupInformationViewVerticalStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [dataLabel, viewsLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isHidden = true
        return stackView
    }
    
    func setupDataLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupViewsLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        return label
    }
    
    func setupViewsHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(perDayButton)
        stackView.addArrangedSubview(perWeekButton)
        stackView.addArrangedSubview(perMonthButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupGenderHorizontalStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [genderPerDayButton, genderPerWeekButton, genderPerMonthButton, genderPerAllButton])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setupButton(withTitle state: Frequency) -> UIButton {
        let button = UIButton()
        button.setTitle(state.toLineGraphString(), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(resource: .border).cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupHeaderLabel() -> UILabel {
        let label = UILabel()
        label.text = "Статистика"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupClientsLabel() -> UILabel {
        let label = UILabel()
        label.text = "Посетители"
        label.font = .boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupPerDayButton() -> UIButton {
        let button = UIButton()
        button.setTitle("По дням", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func setupPerMonthButton() -> UIButton {
        let button = UIButton()
        button.setTitle("По месяцам", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }
    
    func setupPerWeekButton() -> UIButton {
        let button = UIButton()
        button.setTitle("По неделям", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }
    
    func setupRecentCheckLabel() -> UILabel {
        let label = UILabel()
        label.text = "Чаще всех посещают Ваш профиль"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupGenderAndAgeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Пол и возраст"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupObserversLabel() -> UILabel {
        let label = UILabel()
        label.text = "Наблюдатели"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setupUsersTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 14
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
}

// MARK: @objc action
private extension StatisticsView {
    @objc private func viewsButtonTapped(_ sender: UIButton) {
        viewsSelectedButton?.isSelected = false
        sender.isSelected = true
        viewsSelectedButton = sender
        updateViewsButtonStyles()
    }
    
    @objc private func genderButtonTapped(_ sender: UIButton) {
        genderSelectedButton?.isSelected = false
        sender.isSelected = true
        genderSelectedButton = sender
        updateGenderButtonStyles()
    }
}

// MARK: Setup Buttons
private extension StatisticsView {
    private func setupButtonActions() {
        perDayButton.addTarget(self, action: #selector(viewsButtonTapped(_:)), for: .touchUpInside)
        perMonthButton.addTarget(self, action: #selector(viewsButtonTapped(_:)), for: .touchUpInside)
        perWeekButton.addTarget(self, action: #selector(viewsButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupGenderButtons() {
        genderPerDayButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        genderPerWeekButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        genderPerMonthButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        genderPerAllButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
      }
       
    private func updateViewsButtonStyles() {
        let selectedColor = UIColor(resource: .button)
        let normalColor = UIColor.white
        
        perDayButton.backgroundColor = (viewsSelectedButton == perDayButton) ? selectedColor : normalColor
        perMonthButton.backgroundColor = (viewsSelectedButton == perMonthButton) ? selectedColor : normalColor
        perWeekButton.backgroundColor = (viewsSelectedButton == perWeekButton) ? selectedColor : normalColor
    }
    
    private func updateGenderButtonStyles() {
        let selectedColor = UIColor(resource: .button)
        let normalColor = UIColor.white
        
        genderPerDayButton.backgroundColor = (genderSelectedButton == genderPerDayButton) ? selectedColor : normalColor
        genderPerWeekButton.backgroundColor = (genderSelectedButton == genderPerWeekButton) ? selectedColor : normalColor
        genderPerMonthButton.backgroundColor = (genderSelectedButton == genderPerMonthButton) ? selectedColor : normalColor
        genderPerAllButton.backgroundColor = (genderSelectedButton == genderPerAllButton) ? selectedColor : normalColor
        
   }
}

extension StatisticsView {

}

extension StatisticsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
}
