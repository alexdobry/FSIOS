//
//  MultipeerBrowserCellTableViewCell.swift
//  GlobeNew
//
//  Created by Dennis Dubbert on 07.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class MultipeerBrowserCell: UITableViewCell {
    @IBOutlet weak var peerImage: UIImageView!
    @IBOutlet weak var peerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
