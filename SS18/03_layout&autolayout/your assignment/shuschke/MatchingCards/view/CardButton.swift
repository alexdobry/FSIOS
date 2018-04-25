//
//  CardButton.swift
//  MatchingCards
//
//  Created by Alex on 25.04.18.
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
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
    }

    @IBInspectable
    var cardTitle: String? {
        didSet {
            let options: UIViewAnimationOptions = cardTitle != nil ? .transitionFlipFromLeft : .transitionFlipFromRight
            
            UIView.transition(
                with: self,
                duration: 0.3,
                options: options,
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
    
    private func updateCard() {
        if let cardTitle = cardTitle {
            setBackgroundImage(UIImage(named: "card_front", in: Bundle(for: type(of: self)), compatibleWith: traitCollection), for: .normal)
            setTitle(cardTitle, for: .normal)
        } else {
            setBackgroundImage(UIImage(named: "card_back", in: Bundle(for: type(of: self)), compatibleWith: traitCollection), for: .normal)
            setTitle("", for: .normal)
        }
    }
    
    private func disableIfNeeded() {
        isUserInteractionEnabled = !matched
        alpha = matched ? 0.5 : 1.0
    }
}
