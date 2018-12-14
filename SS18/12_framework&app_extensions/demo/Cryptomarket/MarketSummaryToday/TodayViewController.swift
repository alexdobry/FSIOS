//
//  TodayViewController.swift
//  MarketSummaryToday
//
//  Created by Alex on 04.07.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import NotificationCenter
import CryptomarketKit

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak private var leadingStackView: UIStackView!
    @IBOutlet weak private var trailingStackView: UIStackView!
    
    
    @IBOutlet weak private var timestampLabel: UILabel!
    @IBOutlet weak private var marketNameLabel: UILabel!
    @IBOutlet weak private var lastValueLabel: UILabel!
    @IBOutlet weak private var lowValueLabel: UILabel!
    @IBOutlet weak private var highValueLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    @objc func onTap() {
        guard let market = UserDefaults.grouped.market,
            let data = try? PropertyListEncoder().encode(market),
            let url = URL(string: "MSToday://?market=\(data.base64EncodedString())")
        else { return }
    
        extensionContext?.open(url, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        debugPrint(#function)
        
        if let market = UserDefaults.grouped.market {
            MarketSummaryService.default(with: market).marketSummaries { result in
                switch result {
                case .success(let s):
                    if let newest = s.sorted(by: { $0.timestamp < $1.timestamp }).last {
                        self.timestampLabel.text = timeFormatter.string(from: newest.timestamp)
                        self.marketNameLabel.text = market.name
                        self.lastValueLabel.text = readableCurrency(of: newest.last, basedOnCurrency: market.baseCurrency)
                        self.lowValueLabel.text = readableCurrency(of: newest.low, basedOnCurrency: market.baseCurrency)
                        self.highValueLabel.text = readableCurrency(of: newest.high, basedOnCurrency: market.baseCurrency)
                        
                        completionHandler(.newData)
                    } else {
                        completionHandler(.noData)
                    }
                case .failure(let e):
                    debugPrint(#function, e.localizedDescription)
                    completionHandler(.failed)
                }
            }
        } else {
            completionHandler(.noData)
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        debugPrint(#function, activeDisplayMode, maxSize)
        
        switch activeDisplayMode {
        case .expanded:
            (leadingStackView.arrangedSubviews[2...3] + trailingStackView.arrangedSubviews[1...2])
                .forEach { $0.isHidden = false }
            
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110 + 2*18)
        case .compact:
            (leadingStackView.arrangedSubviews[2...3] + trailingStackView.arrangedSubviews[1...2])
                .forEach { $0.isHidden = true }
            
            self.preferredContentSize = maxSize
        }
    }
    
}
