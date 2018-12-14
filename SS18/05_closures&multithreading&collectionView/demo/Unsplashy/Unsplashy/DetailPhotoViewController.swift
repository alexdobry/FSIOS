//
//  DetailPhotoViewController.swift
//  Unsplashy
//
//  Created by Alex on 09.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController, UIScrollViewDelegate {

    var image: UIImage?

    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        scrollView.contentSize = imageView.frame.size
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
