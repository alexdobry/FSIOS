//
//  MarketSummaryChartViewController.swift
//  Cryptomarket
//
//  Created by Alex on 25.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import Charts
import CryptomarketKit

class MarketSummaryChartViewController: LineChartViewController, LineChartViewDataSource {
    
    // MARK: - Public API
    
    var marketSummaries: [MarketSummary] = []
    
    var market: Market?
    
    // MARK: - Outlets
    
    @IBOutlet weak internal var lineChartView: LineChartView!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
    }
    
    // MARK: - LineChartViewDataSource
    
    var animated: Bool = true
    
    var chartDataEntries: [ChartDataEntry] {
        return marketSummaries.sorted(by: { $0.timestamp < $1.timestamp })
            .enumerated()
            .map { ChartDataEntry(x: Double($0.offset), y: $0.element.last, data: $0.element as AnyObject) }
    }
    
    func coDomainAxsisForZooming() -> ChartCoDomainAxsis? {
        guard let min = marketSummaries.min(by: { $0.last < $1.last })?.last,
            let max = marketSummaries.max(by: { $0.last < $1.last })?.last
        else { return nil }
        
        let avg = marketSummaries.reduce(0.0) { $0 + $1.last } / Double(marketSummaries.count)
        
        return ChartCoDomainAxsis(min: min, max: max, avg: avg)
    }
    
    func chartLimitLine(for position: ChartLimitLine.LabelPosition) -> ChartLimitLine? {
        guard let newest = marketSummaries.sorted(by: { $0.timestamp < $1.timestamp }).last,
            let market = market
        else { return nil }

        switch position {
        case .rightTop:
            let v = newest.high
            return ChartLimitLine(limit: v, label: readableCurrency(of: v, basedOnCurrency: market.baseCurrency))
        case .rightBottom:
            let l = newest.low
            return ChartLimitLine(limit: l, label: readableCurrency(of: l, basedOnCurrency: market.baseCurrency))
        case .leftTop, .leftBottom:
            return nil
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
