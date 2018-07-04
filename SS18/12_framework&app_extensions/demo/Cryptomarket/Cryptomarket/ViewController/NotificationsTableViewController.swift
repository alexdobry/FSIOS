//
//  NotificationsTableViewController.swift
//  Cryptomarket
//
//  Created by Alex on 27.06.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class NotificationsTableViewController: EmptyDataTableViewController, EmptyDataTableViewDataSource {
    
    var headline: String {
        return "Enable \"Notifications\" in order to continue"
    }
    
    var content: String {
        return "\n\nYes, open settings"
    }
    
    var isEmpty: Bool {
        return !permissionGranted
    }
    
    var numberOfSections: Int {
        return 1
    }
    
    var emptyScreenTapped: (() -> Void)? { // send user to settings vc
        return {
            guard let bundleIdentifier = Bundle.main.bundleIdentifier, let settingsURL = URL(string: UIApplicationOpenSettingsURLString + bundleIdentifier) else { return }
            
            UIApplication.shared.open(settingsURL, options: [:]) { [weak self] success in
                guard success else { return }
                
                // viewWillAppear does not work when using "back to app" button. thus we need to observe foreground changes as soon as we open settings vc (where things might happen)
                self?.foregroundObserver = NotificationCenter.default.addObserver(forName: Notification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) { _ in
                    self?.validateNotificationStatus()
                }
            }
        }
    }
    
    var markets: [Market] = []
    
    private var selected: Market?
    private var permissionGranted: Bool = false
    private let service: MarketNotificationService = MarketNotificationService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyDataDataSource = self
        
        validateNotificationStatus() // check how to proceed
    }
    
    deinit { debugPrint(#file, #function) }
    
    private func validateNotificationStatus() {
        if let observer = foregroundObserver { // unregister when status changes
            NotificationCenter.default.removeObserver(observer)
        }
        
        // check notification status and request if needed. handle different cases by enable/disable functionality
        service.status(authorized: {
            debugPrint(#function, "authorized")
            self.continue()
        }, notDetermined: {
            debugPrint(#function, "notDetermined")
            self.service.requestAuthorization { granted in
                if granted {
                    self.continue()
                } else {
                    self.abort()
                }
            }
        }, denied: {
            debugPrint(#function, "denied")
            self.abort()
        })
    }
    
    private func `continue`() {
        permissionGranted = true
        selected = UserDefaults.standard.market
        tableView.reloadData()
    }
    
    private func abort() {
        permissionGranted = false
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    private var foregroundObserver: NSObjectProtocol?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketCell", for: indexPath)
        let market = markets[indexPath.row]
        
        cell.textLabel?.text = market.name
        
        if let selected = selected, selected.name == market.name { // checkmark handling
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let market = markets[indexPath.row]
        
        if market.name == selected?.name { // unselect
            selected = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else { // select
            selected = market
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notifications for Market"
    }
    
    @IBAction func done(_ sender: Any) {
        UserDefaults.standard.market = selected // persist if needed
        
        dismiss(animated: true, completion: nil)
    }
}
