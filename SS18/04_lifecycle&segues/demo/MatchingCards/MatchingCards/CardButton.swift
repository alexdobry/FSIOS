//
//  CardButton.swift
//  MatchingCards
//
//  Created by Alex on 29.03.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

@IBDesignable
class CardButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .preferredFont(forTextStyle: .title1)
    }
    
    @IBInspectable
    var cardTitle: String? = nil {
        didSet {
            let option: UIViewAnimationOptions = cardTitle == nil ? .transitionFlipFromRight : .transitionFlipFromLeft
            
            UIView.transition(
                with: self,
                duration: 0.3,
                options: option,
                animations: updateCard,
                completion: nil
            )
        }
    }
    
    @IBInspectable
    var matched: Bool = false {
        didSet {
            UIView.animate(
                withDuration: 0.5,
                animations: disableIfNeeded
            )
        }
    }
    
    private func disableIfNeeded() {
        isUserInteractionEnabled = !matched
        alpha = matched ? 0.5 : 1.0
    }
    
    private func updateCard() {
        if let cardTitle = cardTitle {
            setBackgroundImage(#imageLiteral(resourceName: "card_front"), for: .normal)
            setTitle(cardTitle, for: .normal)
        } else {
            setBackgroundImage(#imageLiteral(resourceName: "card_back"), for: .normal)
            setTitle(nil, for: .normal)
        }
    }
}
