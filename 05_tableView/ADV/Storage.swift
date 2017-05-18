//
//  Storage.swift
//  ADV
//
//  Created by Alex on 14.05.17.
//  Copyright © 2017 Alexander Dobrynin. All rights reserved.
//

import Foundation

final class Storage {
    
    static let CurrentFilterNotificationName = Notification.Name("CurrentFilterNotificationName")
    
    static var cookie: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "cookie")
        }
        get {
            return UserDefaults.standard.string(forKey: "cookie")
        }
    }
    
    static var scheduleEntries: [ScheduleEntry]? {
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue ?? [])
            UserDefaults.standard.set(data, forKey: "scheduleEntries")
        }
        get {
            guard let data = UserDefaults.standard.data(forKey: "scheduleEntries") else { return nil }
            
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? [ScheduleEntry]
        }
    }
    
    static var currentFilter: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "currentFilter")
            
            NotificationCenter.default.post(name: CurrentFilterNotificationName, object: newValue)
        }
        get {
            return UserDefaults.standard.integer(forKey: "currentFilter")
        }
    }
}
