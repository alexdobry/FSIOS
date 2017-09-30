//
//  CarousselMultiplayerView.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 29.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class CarousselGameView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let parent : GameSelectionController
    let game : Game
    
    init(parentController: GameSelectionController, size: CGRect, item: Game) {
        parent = parentController
        game = item
        super.init(frame: size)
        let newWidth = size.width * 0.95
        let newHeight = size.height * 0.95
        let groupView = UIView(frame: CGRect(x: (size.width - newWidth) / 2, y: size.height - newHeight, width: newWidth , height: newHeight))
        //groupView.layer.borderColor = UIColor.white.cgColor
        //groupView.layer.borderWidth = 1
        addSubview(groupView)
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: newWidth, height: newHeight / 6))
        header.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1)
        groupView.addSubview(header)
        
        let title = UILabel()
        title.text = item.name
        title.numberOfLines = 0
        title.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight / 6)
        title.textAlignment = .center
        title.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 25)
        title.textColor = UIColor.white
        header.addSubview(title)
        
        let spacer = UIView(frame: CGRect(x: 0, y: newHeight / 6, width: newWidth, height: 4))
        spacer.backgroundColor = UIColor.white;
        groupView.addSubview(spacer)
        
        let imageFrame = CGRect(x: 0, y: newHeight / 6 + 4, width: newWidth, height: newHeight - (newHeight / 6 + 4))
        let image = UIImageView(frame: imageFrame)
        image.image = UIImage.init(named: item.imageName)
        image.isUserInteractionEnabled = true
        groupView.addSubview(image)
        
        if item.gameType == .single {
            let buttonSize = CGSize(width: newWidth / 1.5, height: imageFrame.height / 8)
            let playButton = UIButton(frame: CGRect(origin: CGPoint(x: newWidth / 2 - buttonSize.width / 2 , y: imageFrame.height / 2 - buttonSize.height / 2) , size: buttonSize))
            
            playButton.setTitle("Start Game", for: .normal)
            playButton.setTitleColor(UIColor.white, for: .normal)
            playButton.titleLabel?.textAlignment = .center
            playButton.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 18)
            playButton.isEnabled = true
            playButton.isUserInteractionEnabled = true
            
            playButton.setBackgroundImage(#imageLiteral(resourceName: "lowButtonBlack"), for: .normal)
            playButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
            image.addSubview(playButton)
        } else {
            let buttonSize = CGSize(width: newWidth / 2.1, height: imageFrame.height / 8)
            let spacing = (newWidth - 2 * buttonSize.width) / 3
            let playButton = UIButton(frame: CGRect(origin: CGPoint(x: spacing, y: imageFrame.height / 2 - buttonSize.height / 2) , size: buttonSize))
            
            playButton.setTitle("Start Lobby", for: .normal)
            playButton.setTitleColor(UIColor.white, for: .normal)
            playButton.titleLabel?.textAlignment = .center
            playButton.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 15)
            playButton.isEnabled = true
            playButton.isUserInteractionEnabled = true
            playButton.setBackgroundImage(#imageLiteral(resourceName: "lowButtonBlack"), for: .normal)
            playButton.addTarget(self, action: #selector(startLobby), for: .touchUpInside)
            image.addSubview(playButton)
            
            let searchButton = UIButton(frame: CGRect(origin: CGPoint(x: newWidth / 2 + spacing / 2, y: imageFrame.height / 2 - buttonSize.height / 2) , size: buttonSize))
            searchButton.setTitle("Search Lobby", for: .normal)
            searchButton.setTitleColor(UIColor.white, for: .normal)
            searchButton.titleLabel?.textAlignment = .center
            searchButton.titleLabel?.font = UIFont(name: "HelveticaNeue-BoldItalic", size: 15)
            searchButton.isEnabled = true
            searchButton.isUserInteractionEnabled = true
            searchButton.setBackgroundImage(#imageLiteral(resourceName: "lowButtonBlack"), for: .normal)
            searchButton.addTarget(self, action: #selector(startSearch), for: .touchUpInside)
            image.addSubview(searchButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startGame() {
        parent.activatedGame = game
        parent.performSegue(withIdentifier: game.name, sender: parent)
    }
    
    func startLobby() {
        parent.activatedGame = game
        parent.performSegue(withIdentifier: "CreateLobby", sender: parent)
    }
    
    func startSearch() {
        parent.activatedGame = game
        parent.performSegue(withIdentifier: "SearchLobby", sender: parent)
    }
}
