//
//  AppDelegate.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        MarketNotificationService.requestAuthorization()
        MarketNotificationService.delegate = self
        window?.tintColor = .tintColor
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint(#function)
        
        let market = Market(baseCurrency: "USDT", logoUrl: nil, currency: "", currencyLong: "", name: "USDT-BTC", active: true) // FIXME: assigment
        MarketSummaryService.with(market: market).deltaFromNetwork { delta in
            if let delta = delta {
                debugPrint(#function, delta)
                
                MarketNotificationService.scheduleNotification(
                    with: market,
                    delta: delta,
                    and: application.applicationIconBadgeNumber
                )
                
                completionHandler(.newData)
            } else {
                completionHandler(.noData)
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint(#function, response.actionIdentifier)
        
        if let data = response.notification.request.content.userInfo.first?.value as? Data,
            let market = try? PropertyListDecoder().decode(Market.self, from: data) {
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let nav = sb.instantiateInitialViewController() as! UINavigationController
            let svc = sb.instantiateViewController(withIdentifier: "MarketSummaryTableViewController") as! MarketSummaryTableViewController
            svc.market = market
            
            nav.pushViewController(svc, animated: true)
            
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint(#function)
        completionHandler([]) // dont show
    }
}
