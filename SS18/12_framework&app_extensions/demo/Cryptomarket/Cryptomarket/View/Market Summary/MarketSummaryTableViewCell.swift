//
//  MarketSummaryTableViewCell.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CryptomarketKit // is this good?

class MarketSummaryTableViewCell: UITableViewCell {
    
    static let Identifier = "MarketSummaryTableViewCell"
    
    @IBOutlet private weak var timestamp: UILabel!
    @IBOutlet private weak var last: UILabel!
    @IBOutlet private weak var delta: UILabel!
    
    func configure(withCurrentValue value: Double, currency: String, delta: MarketSummaryDelta?, andTimestamp date: Date) {
        last.text = readableCurrency(of: value, basedOnCurrency: currency)
        timestamp.text = dateFormatter.string(from: date)
        
        if let delta = delta {
            switch delta.status {
            case .neutral:
                self.delta.textColor = .lightGray
                self.delta.text = "-"
            case .down:
                self.delta.textColor = .coolRed
                self.delta.text = "\(readableCurrency(of: delta.value, basedOnCurrency: currency)) (\(readablePercentage(of: delta.percent)))"
            case .up:
                self.delta.textColor = .coolGreen
                self.delta.text = "\(readableCurrency(of: delta.value, basedOnCurrency: currency)) (\(readablePercentage(of: delta.percent)))"
            }
        } else {
            self.delta.textColor = .lightGray
            self.delta.text = "-"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        last.text = nil
        timestamp.text = nil
        delta.textColor = nil
        delta.text = nil
    }
}
