//
//  ProfileViewController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 28.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    // Properties for profile Images
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    var tapedImageView : UIImageView?
    var demoData = [String : [String]]()
    var singlePlayerDemoData = ["first", "second", "third"]
    var multiPlayerDemoData = ["fourth", "fifth", "sixth"]
    var wantedTableView : String = ""
    
    // Properties for profile table view
    @IBOutlet weak var profileTableView: UITableView! {
        didSet {
            profileTableView.clipsToBounds = true
            profileTableView.layer.borderWidth = 0.7
            profileTableView.layer.borderColor = UIColor.black.cgColor
            
            // Set Seperatro
            profileTableView.separatorStyle = .singleLine
            profileTableView.separatorColor = UIColor.black
            
            // Set Shadow
            addDropShadow(for: profileTableView)
        }
    }
    
    @IBOutlet weak var singlePlayerButton: UIButton! {
        didSet {
            // Set Basics
            singlePlayerButton.layer.borderWidth = 0.7
            singlePlayerButton.layer.borderColor = UIColor.black.cgColor
            
            // Set Shadow
            //addDropShadow(for: singlePlayerButton)
        }
    }
    
    @IBOutlet weak var multiPlayerButton: UIButton! {
        didSet {
            // Set Basics
            multiPlayerButton.layer.borderWidth = 0.7
            multiPlayerButton.layer.borderColor = UIColor.black.cgColor
            
            // Set Shadow
            //addDropShadow(for: multiPlayerButton)
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    

    //MARK: System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateAvatarImage()
        initiateBanner()
        //profileView.backgroundColor = UIColor.init(red: 56/255, green: 55/255, blue: 65/255, alpha: 1)
        userNameLabel.text = "Max Mustermann"
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        wantedTableView = "Single Player"
        demoData["Single Player"] = singlePlayerDemoData
        demoData["Multi Player"] = multiPlayerDemoData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Functions
    // Initiate avatar image with a default image
    func initiateAvatarImage() {
        
        //avatarImageView.frame.size = CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)
        let newImage = ProfileImageMaker.imageMaker.createProfileImage(from: #imageLiteral(resourceName: "EddiDefault"), favoriteColor: .yellow, radius: avatarImageView.frame.width/2)
        
        avatarImageView.image = newImage

        addTabGestureForImageView(view: avatarImageView)
    }
    
    // Initiating banner with a default image
    func initiateBanner() {
        bannerImageView.image = #imageLiteral(resourceName: "BannerDefault")
        addTabGestureForImageView(view: bannerImageView)
    }
    
    //Adding a tab gesture to an ImageView
    func addTabGestureForImageView(view: UIImageView) {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imagePicker)))
    }
    
    // Adding drop shadow for an object like UIButton or UITableView
    func addDropShadow(for object : UIView) {
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowOpacity = 1
        object.layer.shadowOffset = CGSize.zero
        object.layer.shadowRadius = 10
        object.layer.shadowPath = UIBezierPath(rect: object.bounds).cgPath

    }
    
    //
    @IBAction func singlePlayerButtonTapped(_ sender: UIButton) {
        let labelText = sender.titleLabel?.text
        wantedTableView = labelText!
        print(labelText!)
        profileTableView.reloadData()
    }
    
    //
    @IBAction func multiPlayerButtonTapped(_ sender: UIButton) {
        let labelText = sender.titleLabel?.text
        wantedTableView = labelText!
        print(labelText!)
        profileTableView.reloadData()
    }
    
    
    
    
    //MARK: ImagePicker-Functions
    func imagePicker(sender: UITapGestureRecognizer) {
        tapedImageView = sender.view as? UIImageView
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        // Camera-Alert
        let cameraAlert = UIAlertController(title: "Sorry, no permission.", message: "Give permission to camera in your iPhone settings.", preferredStyle: .alert)
        cameraAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        cameraAlert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!) } ))
        
        // PhotoLibrary-Alert
        let photoAlert = UIAlertController(title: "Sorry, no permission.", message: "Give permission to photo library in your iPhone settings", preferredStyle: .alert)
        photoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        photoAlert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!) } ))
        
        // Action-Sheet-Object
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        // Action-Sheet-Camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
                // Already Authorized
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                    if granted == true {
                        // User Granted
                        imagePickerController.sourceType = .camera
                        self.present(imagePickerController, animated: true, completion: nil)
                    } else {
                        // User Rejected
                        self.present(cameraAlert, animated: true, completion: nil)
                    }
                })
            }
        }))
        
        // Action-Sheet-PhotoLibrary
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            
            if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized {
                // Already Authorized
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted :Bool) -> Void in
                    if granted == true {
                        // User Granted
                        imagePickerController.sourceType = .photoLibrary
                        self.present(imagePickerController, animated: true, completion: nil)
                    } else {
                        // User Rejected
                        self.present(photoAlert, animated: true, completion: nil)
                    }
                })
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        if tapedImageView == bannerImageView {
            tapedImageView?.image = image
        } else if tapedImageView == avatarImageView {
            tapedImageView?.image = ProfileImageMaker.imageMaker.createProfileImage(from: image, favoriteColor: .yellow, radius: avatarImageView.frame.width/2)
        }
        //tapedImageView?.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // --------------- Table View Stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (demoData[wantedTableView]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cellData : String
        
        if wantedTableView == "Single Player" {
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "SinglePlayerCell", for: indexPath) as! SinglePlayerCellController
            cellData = singlePlayerDemoData[indexPath.row]
            cell.cellLabel.text = cellData
            return cell
        } else {
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "MultiPlayerCell", for: indexPath) as! MultiPlayerCellController
            cellData = multiPlayerDemoData[indexPath.row]
            cell.cellLabel.text = cellData
            return cell
        }
        
        //return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 10
    }


}
