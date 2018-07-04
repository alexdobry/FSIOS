//
//  MarketSummaryDashboardViewController.swift
//  Cryptomarket
//
//  Created by Alex on 27.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CryptomarketKit

enum Dashboard: Int {
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
    
    private lazy var lvc: MarketSummaryTableViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MarketSummaryTableViewControllerID") as! MarketSummaryTableViewController
        vc.market = market
        return vc
    }()
    
    private lazy var cvc: MarketSummaryChartViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MarketSummaryChartViewControllerID") as! MarketSummaryChartViewController
        vc.market = market // FIXME: ???
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        guard let market = market else { return }
        
        let segmentedControl = UISegmentedControl()
        
        Dashboard.all.forEach { entry in
            segmentedControl.insertSegment(withTitle: "\(market.name) \(entry.title)", at: entry.rawValue, animated: true)
        }
        
        segmentedControl.addTarget(self, action: #selector(dashboardSelected(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        dashboardSelected(segmentedControl)
        
        navigationItem.titleView = segmentedControl
    }
    
    @objc func dashboardSelected(_ sender: UISegmentedControl) {
        switch Dashboard(rawValue: sender.selectedSegmentIndex)! {
        case .chart:
            lvc.remove()
            cvc.summaries = lvc.summaries
            add(cvc)
        case .list:
            cvc.remove()
            add(lvc)
        }
    }
}
