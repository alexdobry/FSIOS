//
//  TodayViewController.swift
//  MarketSummaryTodayExtension
//
//  Created by Alex on 31.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import NotificationCenter
import CryptomarketKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // needed for expanding content based on display mode
    @IBOutlet weak private var firstStackView: UIStackView!
    @IBOutlet weak private var lastStackView: UIStackView!
    
    // simple ui stuff
    @IBOutlet weak private var timestampLabel: UILabel!
    @IBOutlet weak private var marketLabel: UILabel!
    @IBOutlet weak private var lastLabel: UILabel!
    @IBOutlet weak private var lowLabel: UILabel!
    @IBOutlet weak private var highLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded // enable "more" button
    }
    
    @objc func onTap() {
        guard let market = UserDefaults.grouped.market, let url = CMURL.todayExtension(market: market).url else { return }
        
        extensionContext?.open(url, completionHandler: nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        if let market = UserDefaults.grouped.market {
            MarketSummaryService.with(market: market).model(from: .network(storage: false), completion: { result in // added storage bool in order to prevent usage of db in certain cases
                switch result {
                case .success(let s):
                    if let marketSummary = s.sorted(by: { $0.timestamp < $1.timestamp }).last {
                        self.timestampLabel.text = timeFormatter.string(from: marketSummary.timestamp)
                        self.marketLabel.text = marketSummary.name
                        self.lastLabel.text = readableCurrency(of: marketSummary.last, basedOnCurrency: market.baseCurrency)
                        self.lowLabel?.text = readableCurrency(of: marketSummary.low, basedOnCurrency: market.baseCurrency)
                        self.highLabel?.text = readableCurrency(of: marketSummary.high, basedOnCurrency: market.baseCurrency)
                        
                        completionHandler(.newData)
                    } else {
                        completionHandler(.noData)
                    }
                case .failure:
                    completionHandler(.failed)
                }
            })
        } else {
            completionHandler(.noData)
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        debugPrint(#function, activeDisplayMode, maxSize)
        
        switch activeDisplayMode {
        case .expanded:
            firstStackView.arrangedSubviews[2...3].forEach { $0.isHidden = false }
            lastStackView.arrangedSubviews[1...2].forEach { $0.isHidden = false }
            
            self.preferredContentSize = CGSize(width: maxSize.width, height: 110 + 36) // 110 is the default height in .compact. 36 is the calculated height from storyboard (18*2)
        case .compact:
            firstStackView.arrangedSubviews[2...3].forEach { $0.isHidden = true }
            lastStackView.arrangedSubviews[1...2].forEach { $0.isHidden = true }
            
            self.preferredContentSize = maxSize
        }
    }
    
}
