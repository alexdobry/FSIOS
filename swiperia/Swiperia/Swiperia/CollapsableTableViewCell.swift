//
//  CollapsableTableViewCell.swift
//  Swiperia
//
//  Created by Edgar Gellert on 14.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class CollapsableTableViewCell: UITableViewCell {
    
    let separator = UIView(frame: CGRect.zero)
    
    func configure(viewModel: CollapseableViewModel) {
        self.textLabel?.text = viewModel.label
        if viewModel.needsSeperator {
            separator.backgroundColor = UIColor.gray
            contentView.addSubview(separator)
        } else {
            separator.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let separatorHeight = 1 / UIScreen.main.scale
        //separator.frame = CGRect(separatorInset.left, contentView.bounds.height - separatorHeight, contentView.bounds.width - separatorInset.left - separatorInset.right, separatorHeight)
        separator.frame = CGRect(x: Double(separatorInset.left), y: Double(contentView.bounds.height - separatorHeight), width: Double(contentView.bounds.width - separatorInset.left - separatorInset.right), height: Double(separatorHeight))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
