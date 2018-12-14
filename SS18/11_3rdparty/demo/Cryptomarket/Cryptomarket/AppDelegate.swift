//
//  AppDelegate.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import UserNotifications

extension Int {
    func random() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
    var bool: Bool {
        return self % 2 == 0
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let notificationService = MarketNotificationService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = .tintColor
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        notificationService.requestAuthorization { granted in
            debugPrint(#function, granted)
        }
        
        notificationService.delegate = self
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let market = UserDefaults.standard.market {
            MarketSummaryService.default(with: market).marketSummaryDelta { delta in
                if let delta = delta {
                    self.notificationService.scheduleNotification(
                        with: market,
                        delta: delta,
                        currentBages: application.applicationIconBadgeNumber
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let data = response.notification.request.content.userInfo["Market"] as? Data,
            let market = try? PropertyListDecoder().decode(Market.self, from: data) {
            debugPrint(#function, market)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navVC = storyboard.instantiateInitialViewController() as! UINavigationController
            let sumVC = storyboard.instantiateViewController(withIdentifier: "MarketSummaryTableViewControllerID") as! MarketSummaryTableViewController
            sumVC.market = market
            
            navVC.pushViewController(sumVC, animated: true)
            
            window?.rootViewController = navVC  
            window?.makeKeyAndVisible()
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        debugPrint(#function)
        
        completionHandler([]) // dont show notification
    }
}

