//
//  MarketSummaryTableViewController.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MarketSummaryTableViewController: UITableViewController {
    
    // MARK: - Public API
    
    var market: Market?
    
    // MARK: - Model
    
    private var marketSummaries: [(key: DateComponents, value: [MarketSummary])] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Private Properties
    
    private lazy var service = MarketSummaryService.instance(name: market!.name)
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: MarketSummaryTableViewCell.Identifier, bundle: nil),
            forCellReuseIdentifier: MarketSummaryTableViewCell.Identifier
        )
        
        title = market?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let calendar = Calendar.current
        
        service.marketSummaries { (result) in
            switch result {
            case .success(let s):
                self.marketSummaries = s
                    .sorted { $0.timestamp > $1.timestamp }
                    .groupBy { calendar.dateComponents([.year, .month, .day], from: $0.timestamp) }
                    .sorted { $0.key.year! > $1.key.year! }
                
            case .failure(let e):
                print(#function, e.localizedDescription)
            }
        }
            
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return marketSummaries.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marketSummaries[section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketSummaryTableViewCell.Identifier, for: indexPath) as! MarketSummaryTableViewCell
        let current = marketSummaries[indexPath.section].value[indexPath.row]
        
        let previous: MarketSummary? = {
            if let l1 = marketSummaries[safe: indexPath.section]?.value[safe: indexPath.row + 1] {
                return l1
            } else if let l2 = marketSummaries[safe: indexPath.section + 1]?.value.first {
                return l2
            } else {
                return nil
            }
        }()
        
        if let previous = previous {
            let delta = service.delta(between: current, and: previous)
            
            cell.configure(withCurrentValue: current.last, currency: market!.baseCurrency, delta: delta, andTimestamp: current.timestamp)
        } else {
            cell.configure(withCurrentValue: current.last, currency: market!.baseCurrency, delta: nil, andTimestamp: current.timestamp)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return marketSummaries[section].key.string
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
