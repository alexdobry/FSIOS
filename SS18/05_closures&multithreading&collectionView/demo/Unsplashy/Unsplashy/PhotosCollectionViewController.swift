//
//  PhotosCollectionViewController.swift
//  Unsplashy
//
//  Created by Alex on 09.05.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate, PhotosCollectionViewCellDelete {
    
    var imageURls: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(
            UINib(nibName: "PhotosCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        imageURls = (1...27).flatMap { int in
            return URL(string: "http://www.gm.fh-koeln.de/~dobrynin/fsios/images/\(int).jpeg")
        }
        
        registerForPreviewing(with: self, sourceView: collectionView!)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageURls.isEmpty ? 0 : 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotosCollectionViewCell
        
        cell.backgroundColor = .red
        cell.url = imageURls[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow = 3
        let widthWithoutSpacing = collectionView.frame.width - (3 * CGFloat(numberOfItemsPerRow - 1))
        let width = widthWithoutSpacing / CGFloat(numberOfItemsPerRow)
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard !isEditing,
            let detail = storyboard?.instantiateViewController(withIdentifier: "DetailPhotoViewControllerID") as? DetailPhotoViewController,
            let indexPath = collectionView?.indexPathForItem(at: location),
            let cell = collectionView?.cellForItem(at: indexPath) as? PhotosCollectionViewCell,
            let image = cell.image
        else { return nil }
        
        detail.image = image
        detail.preferredContentSize = image.size // fit vc to image size
        previewingContext.sourceRect = cell.frame // sharp
        
        return detail
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    // MARK: Edit
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView?.visibleCells.forEach { cell in
            let photoCell = cell as! PhotosCollectionViewCell
            photoCell.isEditing = editing
            photoCell.delegate = editing ? self : nil
        }
    }
    
    func deleteButtonWasTapped(on cell: PhotosCollectionViewCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        // remove url
        imageURls.remove(at: indexPath.row)
        // collectionView?.reloadData() // force reload
        // remove cell
        collectionView?.deleteItems(at: [indexPath]) // delta update with animation
    }
}
