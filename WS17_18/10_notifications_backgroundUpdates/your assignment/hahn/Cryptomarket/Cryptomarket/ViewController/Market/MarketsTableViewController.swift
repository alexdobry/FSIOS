//
//  MarketsTableViewController.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MarketsTableViewController: UITableViewController {
    
    private struct Storyboard {
        static let MarketSummarySegueIdentifier = "ShowMarketSummarySegue"
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MarketTableViewCell.Identifier, for: indexPath) as! MarketTableViewCell
        let market = markets[indexPath.section].value[indexPath.row]
        
        cell.configure(withImageUrl: market.logoUrl, text: "\(market.currencyLong) (\(market.currency))")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return markets[section].key
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(
            withIdentifier: Storyboard.MarketSummarySegueIdentifier,
            sender: markets[indexPath.section].value[indexPath.row]
        )
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Storyboard.MarketSummarySegueIdentifier:
            let dest = segue.destination as! MarketSummaryTableViewController
            let market = sender as! Market
            
            dest.market = market

        default: break
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
    
//    private func updateMarkets(with summaries: [MarketSummary]) {
//        self.markets = self.markets.map { entry -> (key: String, value: [(market: Market, summaries: Int)]) in
//            let values = entry.value.map { tuple -> (market: Market, summaries: Int) in
//                guard tuple.market.name == summaries.first?.name else { return tuple }
//
//                var mutable = tuple
//                mutable.summaries = summaries.count
//
//                debugPrint("from notification", mutable)
//
//                return mutable
//            }
//
//            return (entry.key, values)
//        }
//    }
}
