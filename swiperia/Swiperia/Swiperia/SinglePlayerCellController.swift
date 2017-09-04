//
//  SinglePlayerCellController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 30.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit

class SinglePlayerCellController: UITableViewCell {
    
    // ImageView in Cell
    @IBOutlet weak var cellImageView: UIImageView!
    // Label in Cell
    @IBOutlet weak var cellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
