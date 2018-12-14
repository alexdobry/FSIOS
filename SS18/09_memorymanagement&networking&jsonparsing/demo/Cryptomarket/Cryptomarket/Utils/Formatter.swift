//
//  Date.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation

let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.dateStyle = .short
    f.timeStyle = .short
    return f
}()

func readableCurrency(of double: Double, basedOnCurrency base: String) -> String {
    switch base {
    case "USDT": return String(format: "%.2f $", double)
    case "BTC": fallthrough
    case "ETH": fallthrough
    case _ : return String(format: "%f %@", double, base)
    }
}

func readablePercentage(of double: Double) -> String {
    if let pos = !double.isLess(than: 0.0) ? "+" : nil {
        return String(format: "%@%.2f%%", pos, double)
    } else {
        return String(format: "%.2f%%", double)
    }
}
