//
//  MarketTableViewCell.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit
import CryptomarketKit // TODO this might be an indicator for bad design

class MarketTableViewCell: UITableViewCell {

    static let Identifier = "MarketTableViewCell"
    
    @IBOutlet private weak var marketImageView: UIImageView!
    @IBOutlet private weak var marketLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    func configure(withImageUrl url: URL?, text: String, count: Int? = nil) {
        marketLabel?.text = text
        countLabel.text = count.map(String.init)
        
        if let url = url {
            fetchImage(url)
        }
    }
    
    private var dedicatedUrl: URL?
    
    private func fetchImage(_ url: URL) {
        dedicatedUrl = url
        
        ImageLoader.shared.imageBy(url: url) { [weak self] (img, reqUrl) in
            guard let strongSelf = self else { return }
            guard reqUrl == strongSelf.dedicatedUrl else { return }
            
            strongSelf.marketImageView.image = img
            strongSelf.marketImageView.alpha = 0.0
            
            UIView.animate(withDuration: 0.3, animations: {
                strongSelf.marketImageView.alpha = 1.0
            })
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        marketImageView.image = nil
        marketLabel.text = nil
        countLabel.text = nil
        dedicatedUrl = nil
    }
}
