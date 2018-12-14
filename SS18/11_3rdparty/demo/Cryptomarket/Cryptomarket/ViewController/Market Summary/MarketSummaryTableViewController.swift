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
    
    var summaries: [MarketSummary] {
        return marketSummaries.flatMap { $0.value }
    }
    
    // MARK: - Model
    
    private var marketSummaries: [(key: DateComponents, value: [MarketSummary])] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Private Properties
    
    private lazy var service: MarketSummaryService = {
        guard let market = market else {
            fatalError("market must be set")
        }
        
        return MarketSummaryService.default(with: market)
    }()
    
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
        
        debugPrint(#file, #function)
        
        let calendar = Calendar.current
        
        service.marketSummaries { [weak self] result in
            switch result {
            case .success(let summaries):
                self?.marketSummaries = summaries
                    .sorted { $0.timestamp > $1.timestamp }
                    .groupBy { calendar.dateComponents([.year, .month, .day], from: $0.timestamp) }
                    .sorted { calendar.date(from: $0.key)! > calendar.date(from: $1.key)! }
                
            case .failure(let error):
                let alert = UIAlertController.withError(error)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint(#file, #function)
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
    }}
