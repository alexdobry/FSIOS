//
//  CryptoCoinBalloonMarker.swift
//  Cryptomarket
//
//  Created by Alex on 30.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Charts
import CryptomarketKit

func format(date: Date, calendar: Calendar = Calendar.current) -> String { // TODO added
    if calendar.isDateInToday(date) { return "Heute, \(timeFormatter.string(from: date))" }
    if calendar.isDateInYesterday(date) { return "Gestern, \(timeFormatter.string(from: date))" }

    return dateFormatter.string(from: date)
}

final class CryptoCoinBalloonMarker: BalloonMarker { // TODO added

    let market: Market

    init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, market: Market) {
        self.market = market

        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }

    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let marketSummary = entry.data as! MarketSummary

        let timestamp = format(date: marketSummary.timestamp) // TODO changed
        let currency = readableCurrency(of: entry.y, basedOnCurrency: market.baseCurrency)

        setLabel("\(timestamp)\n\(currency)")
    }
}

