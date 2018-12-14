//
//  NotificationViewController.swift
//  Cryptomarket
//
//  Created by Didi on 26.09.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    let authenticationView = AuthenticationView()
    
    let center = UNUserNotificationCenter.current()
    
    var selectedRow: IndexPath?
     var isEmpty: Bool = Bool()

    var currentMarket: Market?
    var delta: MarketSummaryDelta?
    
    var markets: [(key: String, value: [Market])] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var marketSummaries: [(key: DateComponents, value: [MarketSummary])] = [] {
        didSet { tableView.reloadData() }
    }
    
    private let service = MarketService.default()
    
    private lazy var summaryservice: MarketSummaryService = {
        guard let market = currentMarket else {
            fatalError("market must be set")
        }

        return MarketSummaryService.default(with: market)
    }()
    
    
    // MARK: Code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set isEmpty, wenn Notification erlaubt/ nicht erlaubt sind
        center.getNotificationSettings { (settings) in
            if(settings.authorizationStatus == .authorized)
            {
                self.isEmpty = false
            }
            else
            {
                self.isEmpty = true
            }
        }
    
    }

    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()

        //Vom Alex geklaut:
        service.markets { [weak self] result in
            switch result {
            case .success(let markets):
                self?.markets = markets
                    .filter { $0.active }
                    .groupBy { $0.baseCurrency } // ["USDT": [BTC, XRP], "BTC": [ENG]]
                    .sorted { $0.key > $1.key } // [("USDT", [BTC, XRP]), ("BTC", [ENG])]
            case .failure(let error):
                let alert = UIAlertController.withError(error)
                self?.present(alert, animated: true, completion: nil)
            }
            
        }
        
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEmpty {
            self.tableView.backgroundView = self.authenticationView
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = false
            return 0
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView?.isHidden = true
            return markets.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath)
        let market = markets[indexPath.section].value[indexPath.row]
        cell.textLabel?.text = market.name
        
        
        //Assignment:
//        let current = marketSummaries[safe: indexPath.section]?.value[safe: indexPath.row]
//
//
//
//
//         delta = summaryservice.delta(between: current!, and: previous!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(#function)

        // Bei Selektion, setze Checkmark und setze ausgewählten market
        if selectedRow == nil {
            selectedRow = indexPath
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            currentMarket = markets[indexPath.section].value[indexPath.row]
        }
        
        if selectedRow != indexPath {
            self.tableView.cellForRow(at: selectedRow!)?.accessoryType = .none
            selectedRow = indexPath
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            currentMarket = markets[indexPath.section].value[indexPath.row]
        }
        
        //vom Alex
            let previous: MarketSummary? = {
                if let l1 = marketSummaries[safe: indexPath.section]?.value[safe: indexPath.row + 1] {
                    return l1
                } else if let l2 = marketSummaries[safe: indexPath.section + 1]?.value.first {
                    return l2
                } else {
                    return nil
                }
            }()

        self.tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let cm = currentMarket else { return }
        
        let notification = MarketNotificationService()
        //notification.scheduleNotification(with: cm, delta: delta!, currentBages: 0)
    }

    
}




