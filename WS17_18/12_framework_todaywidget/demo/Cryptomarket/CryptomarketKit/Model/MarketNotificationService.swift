//
//  NotificationService.swift
//  Cryptomarket
//
//  Created by Alex on 15.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import Foundation
import UserNotifications

public final class MarketNotificationService {
    
    private static let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
    
    public static var delegate: UNUserNotificationCenterDelegate? {
        get { return center.delegate }
        set { center.delegate = newValue }
    }
    
    private init() { }
    
    public static func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if let error = error {
                debugPrint(#function, error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    public typealias StatusClosure = () -> Void
    
    public static func status(authorized: @escaping StatusClosure,
                       notDetermined: @escaping StatusClosure,
                       denied: @escaping StatusClosure) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized: authorized()
                case .notDetermined: notDetermined()
                case .denied: denied()
                }
            }
        }
    }
    
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
    
    public static func scheduleNotification(with market: Market,
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
