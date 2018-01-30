//
//  NotificationTableViewController.swift
//  Cryptomarket
//
//  Created by Uwe Müsse on 30.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class NotificationTableViewController: EmptyDataTableViewController {
    
    var markets: [(key: String, value: [Market])] = []
    var selectedMarket: Market?
    
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = defaults.object(forKey: "selectedMarket") as? Data {
            let decoder = PropertyListDecoder()
            selectedMarket = try? decoder.decode(Market.self, from: data)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return markets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markets[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let market = markets[indexPath.section].value[indexPath.row]

        if let selected = selectedMarket, selected.name == market.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = market.currency
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return markets[section].key
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let selectedCell = cell?.accessoryType == .checkmark
        
        clearAccessoryTypes()
        
        if selectedCell{
           cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
            let market = markets[indexPath.section].value[indexPath.row]
            let encoder = PropertyListEncoder()
            let data = try? encoder.encode(market)
            defaults.set(data, forKey: "selectedMarket")
        }
        
        
    }
    
    func clearAccessoryTypes (){
        for section in 0..<self.tableView.numberOfSections{
            for row in 0..<self.tableView.numberOfRows(inSection: section){
                let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: section))
                cell?.accessoryType = .none
            }
        }
    }
}
