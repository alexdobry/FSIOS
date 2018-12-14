//
//  PhotosCollectionViewCell.swift
//  Unsplashy
//
//  Created by Alex on 09.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

protocol PhotosCollectionViewCellDelete {
    func deleteButtonWasTapped(on cell: PhotosCollectionViewCell)
}

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var deleteView: UIVisualEffectView! {
        didSet {
            deleteView.layer.cornerRadius = deleteView.frame.width / 2
            deleteView.clipsToBounds = true
        }
    }
    
    var url: URL? {
        didSet { updateUI() }
    }
    
    var image: UIImage? {
        return imageView.image
    }
    
    var isEditing: Bool {
        get { return !deleteView.isHidden }
        set { deleteView.isHidden = !newValue }
    }
    
    var delegate: PhotosCollectionViewCellDelete?
    
    private var cookie: URL?
    
    private func updateUI() {
        guard let url = url else { return }
        cookie = url
        
        ImageLoader.default.imageBy2(url: url) { image in
            if self.cookie == url {
                self.imageView.image = image // main
            } else {
                print("wrong image here")
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteButtonWasTapped(on: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        cookie = nil
        url = nil
    }
}
