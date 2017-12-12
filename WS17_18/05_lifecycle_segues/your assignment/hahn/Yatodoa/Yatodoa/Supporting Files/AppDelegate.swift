//
//  AppDelegate.swift
//  Done
//
//  Created by Alex on 11.10.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        debugPrint("\(#function)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        debugPrint(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        debugPrint("\(#function)")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        debugPrint("\(#function)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        debugPrint("\(#function)")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        debugPrint("\(#function)")
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        debugPrint("\(#function)")
    }
}

