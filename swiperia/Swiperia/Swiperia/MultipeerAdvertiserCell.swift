//
//  MultipeerAdvertiserCell.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 29.08.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class MultipeerAdvertiserCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var peerImage: UIImageView!
    @IBOutlet weak var peerName: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
