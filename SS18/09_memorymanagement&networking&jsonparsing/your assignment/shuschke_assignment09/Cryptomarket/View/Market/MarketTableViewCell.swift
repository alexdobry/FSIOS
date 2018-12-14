//
//  MarketTableViewCell.swift
//  Cryptomarket
//
//  Created by Alex on 05.01.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class MarketTableViewCell: UITableViewCell {

    static let Identifier = "MarketTableViewCell"
    
    @IBOutlet private weak var marketImageView: UIImageView!
    @IBOutlet private weak var marketLabel: UILabel!
    
    func configure(withImageUrl url: URL?, andText text: String) {
        marketLabel?.text = text
        
        if let url = url {
            fetchImage(url)
        }
    }

    private var dedicatedUrl: URL?
    
    private func fetchImage(_ url: URL) {
        dedicatedUrl = url
        
        ImageLoader.shared.image(by: url) { (img, reqUrl) in
            guard reqUrl == self.dedicatedUrl else { return }
            
            self.marketImageView.image = img
            self.marketImageView.alpha = 0.0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.marketImageView.alpha = 1.0
            })
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        marketImageView.image = nil
        marketLabel.text = nil
        dedicatedUrl = nil
    }
}
