//
//  MarketNotificationService.swift
//  Cryptomarket
//
//  Created by Alex on 20.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UserNotifications

final class MarketNotificationService {
    
    private let center = UNUserNotificationCenter.current()
    
    var delegate: UNUserNotificationCenterDelegate? {
        get { return center.delegate }
        set { center.delegate = newValue }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                debugPrint(#function, error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleNotification(with market: Market, delta: MarketSummaryDelta, currentBages: Int) {
        let content = UNMutableNotificationContent()
        content.title = "\(market.name) is going \(delta.status.string)"
        content.subtitle = "by \(readableCurrency(of: delta.value, basedOnCurrency: market.baseCurrency)) (\(readablePercentage(of: delta.percent)))"
        content.badge = currentBages + 1 as NSNumber
        content.sound = .default()
        content.userInfo = [
            "Market": try! PropertyListEncoder().encode(market)
        ]
        
        let identifier = String(Date().timeIntervalSince1970)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil // fire immediately
        )
        
        center.add(request, withCompletionHandler: nil)
    }
}
