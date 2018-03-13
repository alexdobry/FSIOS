//
//  NotificationTableViewController.swift
//  Cryptomarket
//
//  Created by Christian Hahn on 29.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class NotificationTableViewController: UITableViewController {
    
    // MARK: - Model
    
    var markets: [(key: String, value: [Market])] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Private Properties
    
    private let service = MarketService.instance()
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: MarketTableViewCell.Identifier, bundle: nil),
            forCellReuseIdentifier: MarketTableViewCell.Identifier
        )
        
        service.model(from: .both, completion: handle)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        let control = sender ?? refreshControl!
        
        if !control.isRefreshing {
            let offset = CGPoint(x: 0, y: tableView.contentOffset.y - control.frame.size.height)
            tableView.setContentOffset(offset, animated: true)
            control.beginRefreshing()
        }
        
        service.model(from: .network) { [weak self] res in
            control.endRefreshing()
            
            self?.handle(res)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return markets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let market = markets[indexPath.section].value[indexPath.row]
        
        let defaults = UserDefaults.standard
        let json = defaults.object(forKey: "NotificationsForMarket") as? Data
        if let json = json {
            
            let decoder = PropertyListDecoder()
            if let decoded = try? decoder.decode(Market.self, from: json) {
                cell.accessoryType = market.name == decoded.name ? .checkmark : .none
            }
            
        }
        
        cell.textLabel?.text = market.currency
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return markets[section].key
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "NotificationsForMarket")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        
        let status = cell?.accessoryType
        
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                    cell.accessoryType = .none
                }
            }
        }
        
        if status == .checkmark {
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
            let encoder = PropertyListEncoder()
            let market = markets[indexPath.section].value[indexPath.row]
            if let encoded = try? encoder.encode(market) {
                defaults.set(encoded, forKey: "NotificationsForMarket")
            }
        }
        
        
        
    }
    
    // MARK: - Helper
    
    private func presentAlert(for error: Error) {
        let alert = UIAlertController(
            title: "Server Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Erneut Versuchen",
            style: .default,
            handler: { _ in self.refresh(nil) })
        )
        
        alert.addAction(UIAlertAction(
            title: "Verstanden",
            style: .cancel,
            handler: nil)
        )
        
        present(alert, animated: true, completion: nil)
    }
    
    private func handle(_ result: Result<[Market]>) {
        switch result {
        case let .failure(e):
            self.presentAlert(for: e)
            
        case let .success(s):
            self.markets = s
                .filter { $0.active }
                .groupBy { $0.baseCurrency }
                .sorted { $0.key > $1.key }
        }
    }
}
