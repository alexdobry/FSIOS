//
//  GameSelectionController.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 11.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import UIKit

class GameSelectionController: UIViewController, iCarouselDataSource, iCarouselDelegate {

    //MARK: Properties
    var gameManager = GameManager()
    var items : [Game] = []
    // temporär
    var currentGameMode = GameMode.multi
    var activatedGame : Game?
    
    @IBOutlet weak var carousel: iCarousel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .rotary
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        items = gameManager.getSpecificGameModes(for: currentGameMode)
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing
        view: UIView?) -> UIView {
        
        var itemView: CarousselGameView
        
        // Reuse view if available, otherwise create a new view
        //if let view = view as? CarousselGameView {
            //let size = view.frame
            //itemView = view
            /*itemView.image = resizeImage(image: UIImage(named: items[index].imageName)!, newWidth: size.width, newHeight: size.height)*/
        //} else {
        let size = self.view.frame
        var newWidth = size.width
        var newHeight = size.height - UIApplication.shared.statusBarFrame.height
        if let navBar = self.navigationController?.navigationBar {
            newHeight -= navBar.frame.height
        }
        if let tabBar = self.tabBarController?.tabBar {
            newHeight -= tabBar.frame.height
        }
        
        newHeight *= 0.95
        newWidth *= 0.75
        
            //itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            //itemView.image = resizeImage(image: UIImage(named: items[index].imageName)!, newWidth: newWidth, newHeight: newHeight)
        itemView = CarousselGameView(parentController: self, size: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight), item: items[index])
            itemView.contentMode = .center
            
            // Create Info-Button
            
            // Create Play-Button
            
        //}
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.1
        }
        return value
    }
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateLobby" {
            if let toViewController = segue.destination as? CreateLobbyViewController, let game = activatedGame {
                toViewController.game = game
            }
        }
        if segue.identifier == "SearchLobby" {
            if let toViewController = segue.destination as? MultipeerBrowserViewController, let game = activatedGame {
                toViewController.game = game
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
