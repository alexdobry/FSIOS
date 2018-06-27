//
//  MarketSummaryChartViewController.swift
//  Cryptomarket
//
//  Created by Alex on 27.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import Charts

class MarketSummaryChartViewController: LineChartViewController, LineChartViewDataSource {
    
    // MARK: public API
    
    var market: Market?
    var summaries: [MarketSummary] = []

    // MARK: DataSource
    
    @IBOutlet weak var lineChartView: LineChartView!

    var animated: Bool = true
    
    var chartDataEntries: [ChartDataEntry] {
        return summaries.sorted { $0.timestamp < $1.timestamp }
            .enumerated()
            .map { ChartDataEntry(x: Double($0.offset), y: $0.element.last, data: $0.element as AnyObject) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint(#file, #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint(#file, #function)
    }

    func coDomainAxsisForZooming() -> ChartCoDomainAxsis? {
        let sorted = summaries.sorted { $0.last < $1.last } // 3000 .... 8000
        
        guard let min = sorted.first?.last, let max = sorted.last?.last else {
            return nil
        }
        
        let avg = sorted.reduce(0.0) { $0 + $1.last } / Double(sorted.count)
        
        return ChartCoDomainAxsis(min: min, max: max, avg: avg)
    }
    
    func chartLimitLine(for position: ChartLimitLine.LabelPosition) -> ChartLimitLine? {
        guard let newest = summaries.sorted(by: { $0.timestamp < $1.timestamp }).last else {
            return nil
        }
        
        switch position {
        case .rightTop:
            let label = market != nil ? readableCurrency(of: newest.high, basedOnCurrency: market!.baseCurrency) : "MAX"
            return ChartLimitLine(limit: newest.high, label: label)
        case .rightBottom:
            let label = market != nil ? readableCurrency(of: newest.low, basedOnCurrency: market!.baseCurrency) : "MIN"
            return ChartLimitLine(limit: newest.low, label: label)
        case .leftTop, .leftBottom: return nil
        }
    }
    
    func balloonMarker() -> BalloonMarker? {
        guard let market = market else { return nil }
        
        return CryptoCoinBalloonMarker(
            color: .lightGray,
            font: .systemFont(ofSize: 12),
            textColor: .white,
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
            market: market
        )
    }
}
