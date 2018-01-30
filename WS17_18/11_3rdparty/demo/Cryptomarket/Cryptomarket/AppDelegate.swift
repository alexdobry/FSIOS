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
        
        window?.tintColor = .tintColor
        
        MarketNotificationService.delegate = self
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        let market = Market(baseCurrency: "USDT", logoUrl: nil, currency: "", currencyLong: "", name: "USDT-BTC", active: true) // FIXME: assignment: let user decide which market should be fetched by background updates
        
        if let market = UserDefaults.standard.market {
            MarketSummaryService.with(market: market).deltaFromNetwork { delta in
                if let delta = delta {
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
        } else {
            completionHandler(.noData)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint(#function, "with action:", response.actionIdentifier)
        
        if let data = response.notification.request.content.userInfo.first?.value as? Data, let market = try? PropertyListDecoder().decode(Market.self, from: data) {
            debugPrint(#function, market)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nav = storyboard.instantiateInitialViewController() as! UINavigationController

            let dashboardVC = storyboard.instantiateViewController(withIdentifier: "MarketSummaryDashboardViewController") as! MarketSummaryDashboardViewController
            dashboardVC.market = market

            nav.pushViewController(dashboardVC, animated: true)

            window?.rootViewController = nav
            window?.makeKeyAndVisible()
        }
        
        completionHandler()
    }
    
    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint(#function)
        completionHandler([]) // dont show
    }

}
