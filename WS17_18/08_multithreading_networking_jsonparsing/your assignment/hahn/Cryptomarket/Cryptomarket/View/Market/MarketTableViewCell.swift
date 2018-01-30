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
        self.dedicatedUrl = url
        
        ImageLoader.standard.image(by: url) { [weak self] (img, requestedUrl) in
            guard requestedUrl == self?.dedicatedUrl else { return }
            
            self?.marketImageView.alpha = 0.0
            self?.marketImageView.image = img
            
            UIView.animate(withDuration: 0.4, animations: {
                self?.marketImageView.alpha = 1.0
            })
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        marketImageView.image = nil
        marketLabel.text = nil
    }
}
