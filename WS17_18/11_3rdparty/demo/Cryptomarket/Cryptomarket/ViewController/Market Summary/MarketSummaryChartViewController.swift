//
//  MarketSummaryChartViewController.swift
//  Cryptomarket
//
//  Created by Alex on 30.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import Charts

class MarketSummaryChartViewController: LineChartViewController, LineChartViewDataSource {
    
    var market: Market?
    var marketSummaries: [MarketSummary] = []
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var animated: Bool = true
    
    var chartDataEntries: [ChartDataEntry] {
        return marketSummaries
            .sorted(by: { $0.timestamp < $1.timestamp })
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
        super.viewWillDisappear(animated)
        
        debugPrint(#file, #function)
    }
    
    func coDomainAxsisForZooming() -> ChartCoDomainAxsis? {
        guard let min = marketSummaries.min(by: { $0.last < $1.last })?.last,
        let max = marketSummaries.max(by: { $0.last < $1.last })?.last
        else { return nil }
        
        let avg = marketSummaries.reduce(0.0) { $0 + $1.last } / Double(marketSummaries.count)
        
        return ChartCoDomainAxsis(min: min, max: max, avg: avg)
    }

    func chartLimitLine(for position: ChartLimitLine.LabelPosition) -> ChartLimitLine? {
        guard let latest = marketSummaries.sorted(by: { $0.timestamp < $1.timestamp }).last else { return nil }
        
        switch position {
        case .rightTop: // high
            return ChartLimitLine(limit: latest.high, label: readableCurrency(of: latest.high, basedOnCurrency: market!.baseCurrency))
        case .rightBottom: // low
            return ChartLimitLine(limit: latest.low, label: readableCurrency(of: latest.low, basedOnCurrency: market!.baseCurrency))
        case .leftBottom, .leftTop:
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
