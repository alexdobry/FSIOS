//
//  MarketSummaryViewController.swift
//  Cryptomarket
//
//  Created by Alex on 25.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CryptomarketKit

fileprivate enum Dashboard: Int {
    case list, chart
    
    var title: String {
        switch self {
        case .list: return "List"
        case .chart: return "Chart"
        }
    }
    
    static let all = [list, chart]
}

class MarketSummaryDashboardViewController: UIViewController {

    // MARK: - Public API
    
    var market: Market?
    
    // MARK: - Container ViewController
    
    private lazy var listVC: MarketSummaryTableViewController = {
        let list = storyboard?.instantiateViewController(withIdentifier: "MarketSummaryTableViewController") as! MarketSummaryTableViewController
        list.market = market
        return list
    }()
    
    private lazy var chartVC: MarketSummaryChartViewController = {
        let chart = storyboard?.instantiateViewController(withIdentifier: "MarketSummaryChartViewController") as! MarketSummaryChartViewController
        chart.market = market // later on
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        guard let market = market else { return }
        
        let dashboardControl = UISegmentedControl()
        
        Dashboard.all.forEach {
            dashboardControl.insertSegment(withTitle: "\(market.name) \($0.title)", at: $0.rawValue, animated: false)
        }
        
        dashboardControl.addTarget(self, action: #selector(dashboardSelected(_:)), for: .valueChanged)
        
        navigationItem.titleView = dashboardControl
        
        dashboardControl.selectedSegmentIndex = 0
        dashboardSelected(dashboardControl)
    }
    
    @objc func dashboardSelected(_ sender: UISegmentedControl) {
        switch Dashboard(rawValue: sender.selectedSegmentIndex)! {
        case .list:
            chartVC.remove()
            add(listVC)
        case .chart:
            chartVC.marketSummaries = listVC.summaries // need to be set each time because tvc may be refresh data
            
            listVC.remove()
            add(chartVC)
        }
    }
}
