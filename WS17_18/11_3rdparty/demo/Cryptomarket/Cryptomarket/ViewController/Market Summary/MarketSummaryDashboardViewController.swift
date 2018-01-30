//
//  MarketSummaryDashboardViewController.swift
//  Cryptomarket
//
//  Created by Alex on 30.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

enum MarketSummaryDashboard: Int {
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
    
    private lazy var listVC: MarketSummaryTableViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MarketSummaryTableViewController") as! MarketSummaryTableViewController
        vc.market = market
        return vc
    }()
    
    private lazy var chartVC: MarketSummaryChartViewController = {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MarketSummaryChartViewController") as! MarketSummaryChartViewController
        vc.market = market
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        let seg = UISegmentedControl()
        
        MarketSummaryDashboard.all.forEach {
            seg.insertSegment(withTitle: "\($0.title) \(market!.name)", at: $0.rawValue, animated: false)
        }
        
        seg.addTarget(self, action: #selector(dashboardSelected(_:)), for: .valueChanged)
    
        navigationItem.titleView = seg
        
        seg.selectedSegmentIndex = 0
        dashboardSelected(seg)
    }
    
    @objc func dashboardSelected(_ sender: UISegmentedControl) {
        switch MarketSummaryDashboard(rawValue: sender.selectedSegmentIndex)! {
        case .list:
            chartVC.remove()
            add(listVC)
        case .chart:
            chartVC.marketSummaries = listVC.summaries
            
            listVC.remove()
            add(chartVC)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
