//
//  NearbyBrowserTableViewCell.swift
//  Switcheroo
//
//  Created by Dennis Dubbert on 17.05.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class NearbyBrowserTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
