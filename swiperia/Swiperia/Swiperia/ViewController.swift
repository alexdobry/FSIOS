//
//  ViewController.swift
//  Swiperia
//
//  Created by Dennis Dubbert on 10.06.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit



class ViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    //MARK: Properties
    var gameManager = GameManager()
    var items : [Game] = []
    // temporär
    var currentGameMode = GameMode.multi
    

    @IBOutlet weak var carousel: iCarousel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .invertedCylinder
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
        
        var itemView: UIImageView
        
        // Reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            let size = view.frame
            itemView = view
            itemView.image = resizeImage(image: UIImage(named: items[index].imageName)!, newWidth: size.width, newHeight: size.height)
        } else {
            let size = self.view.frame
            //print(size)
            let newWidth = size.width*0.7
            let newHeight = size.height*0.6
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
            //itemView.image = #imageLiteral(resourceName: "gameModeWindow")
            itemView.image = resizeImage(image: UIImage(named: items[index].imageName)!, newWidth: newWidth, newHeight: newHeight)
            itemView.contentMode = .center
            
            // Create label
//            label = UILabel(frame: itemView.bounds)
//            label.backgroundColor = .clear
//            label.textAlignment = .center
//            label.font = label.font.withSize(50)
//            label.tag = 1
//            itemView.addSubview(label)
            
            // Create Info-Button
            
            // Create Play-Button
            
        }
        
        //label.text = "\(items[index].name)"
        //label.text = "\(gameModeMultiPlayerView[index].name)"
        
        
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

}

