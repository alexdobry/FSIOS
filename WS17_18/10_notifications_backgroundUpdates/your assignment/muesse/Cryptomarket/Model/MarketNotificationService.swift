//
//  NotificationService.swift
//  Cryptomarket
//
//  Created by Alex on 15.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UserNotifications

final class MarketNotificationService {

    private static let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    static var delegate: UNUserNotificationCenterDelegate? {
        get { return center.delegate }
        set { center.delegate = newValue }
    }
    
    private init() { }
    
    private static func notificationContent(with market: Market,
                                            delta: MarketSummaryDelta,
                                            and currentBadges: Int) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "\(market.name) is going \(delta.status.string)"
        content.subtitle = "by \(readableCurrency(of: delta.value, basedOnCurrency: market.baseCurrency)) (\(readablePercentage(of: delta.percent)))"
        content.badge = currentBadges + 1 as NSNumber
        content.sound = .default()
        content.userInfo = ["Data" : try! PropertyListEncoder().encode(market)]
        
        return content
    }
    
    static func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                debugPrint(#function, error.localizedDescription)
            }
            
            debugPrint(#function, granted)
        }
    }
    
    static func scheduleNotification(with market: Market,
                                     delta: MarketSummaryDelta,
                                     and currentBadges: Int) {
        let content = notificationContent(with: market, delta: delta, and: currentBadges)
        
        let request = UNNotificationRequest(
            identifier: String(Date().timeIntervalSince1970),
            content: content,
            trigger: nil
        )
        
        center.add(request, withCompletionHandler: nil)
    }
}
