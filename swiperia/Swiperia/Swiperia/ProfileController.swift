//
//  ProfileController.swift
//  Swiperia
//
//  Created by Edgar Gellert on 28.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    //MARK: - UserDefaults AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var settingStore = [String : Any]()
    var singleStore = [String : Any]()
    var multiStore = [String : Any]()
    
    
    //MARK: - Properties --------------------------------------------------
    // Properties for profile Images
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var singlePlayerButton: UIButton! {
        didSet {
            // Set Basics
            singlePlayerButton.layer.borderWidth = 0.7
            singlePlayerButton.layer.borderColor = UIColor.black.cgColor
            singlePlayerButton.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet weak var multiPlayerButton: UIButton! {
        didSet {
            // Set Basics
            multiPlayerButton.layer.borderWidth = 0.7
            multiPlayerButton.layer.borderColor = UIColor.black.cgColor
            multiPlayerButton.layer.cornerRadius = 15
        }
    }
    
    var tapedImageView : UIImageView?
    var demoData = [String : [String]]()
    var singlePlayerDemoData = ["first", "second", "third"]
    var multiPlayerDemoData = ["fourth", "fifth", "sixth"]
    var wantedTableView : String = "Singleplayer"
    var currentTypedUserName : String? = ""

    
    // Properties for profile table view
    @IBOutlet weak var profileTableView: UITableView! {
        didSet {
            profileTableView.clipsToBounds = true
            profileTableView.layer.borderWidth = 0.7
            profileTableView.layer.borderColor = UIColor.black.cgColor
            
            // Set Seperator
            profileTableView.separatorStyle = .singleLine
            profileTableView.separatorColor = UIColor.black
            
            // Set Shadow
            addDropShadow(for: profileTableView)
        }
    }
    
    //MARK: - System Functions --------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingStore = appDelegate.settings
        singleStore = appDelegate.singlePlayerScores
        multiStore = appDelegate.multiPlayerScores
        
        checkUserDefaults(settings: settingStore)
        
//        initiateAvatarImage()
//        initiateBanner()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        wantedTableView = "Singleplayer"
        demoData["Singleplayer"] = singlePlayerDemoData
        demoData["Multiplayer"] = multiPlayerDemoData
        
        userNameTextField.delegate = self
        
        userNameTextField.textColor = .black
        setTextFieldBorder()
        
        displayedRows = data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //checkForProfileUserDefaults()
    }
    
    
    
    
    //MARK: - Functions --------------------------------------------------
    // Check auf UserDefaults
    func checkUserDefaults(settings : [String:Any]) {
        // Check auf UserName
        if let userName = settings["userName"] as? String {
            userNameTextField.text = userName
            setTextFieldBorder()
        } else {
            setTextFieldBorder()
        }
        
        // Setzen des Default Banner Image
        let bannerImage = settings["userBanner"] as! UIImage
        initiateBanner(banner: bannerImage)
        
        // Setzen des Default Avatar Image
        let avatarImage = settings["userImage"] as! UIImage
        initiateAvatarImage(avatar: avatarImage)
    }
    
    // Initiate avatar image with a default image
    func initiateAvatarImage(avatar : UIImage) {
        let newImage = ProfileImageMaker.imageMaker.createProfileImage(from: avatar, favoriteColor: .yellow, radius: avatarImageView.frame.width/2)
        avatarImageView.image = newImage
        addTabGestureForImageView(view: avatarImageView)
    }
    
    // Initiating banner with a default image
    func initiateBanner(banner : UIImage) {
        bannerImageView.image = banner
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
    
    // Hide Keyboard when user touches outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
    }
    
    // User pressed "done" on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.text = textField.text
        userNameTextField.resignFirstResponder()
        setTextFieldBorder()
        checkUserNameInput()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTypedUserName = textField.text
    }
    
    func checkUserNameInput() {
        if (userNameTextField.text?.isEmpty)! {
            userNameTextField.text = currentTypedUserName
            setTextFieldBorder()
        }
    }
    
    // Set the user text field border if a user name is set
    func setTextFieldBorder() {
        if userNameTextField.text != nil {
            if userNameTextField.text!.isEmpty {
                userNameTextField.borderStyle = .roundedRect
                userNameTextField.placeholder = "Type in your name!"
                userNameTextField.textColor = .black
                userNameTextField.backgroundColor = .white
            } else {
                userNameTextField.borderStyle = .none
                userNameTextField.textColor = .white
                userNameTextField.backgroundColor = .clear
            }
            
        } else {
            userNameTextField.borderStyle = .roundedRect
            userNameTextField.placeholder = "Type in your name!"
            userNameTextField.textColor = .black
            userNameTextField.backgroundColor = .white
        }
    }
    
//    func checkForProfileUserDefaults() {
//        if let userName = store.object(forKey: UserDefaults.UserDefaultKeys.userName.rawValue) {
//            userNameTextField.text = userName as? String
//        }
//        if let userProfileImage = store.object(forKey: UserDefaults.UserDefaultKeys.userProfileImage.rawValue) {
//            avatarImageView.image = store.getImage(forKey: userProfileImage as! String)
//        }
//        if let profileBannerImage = store.object(forKey: UserDefaults.UserDefaultKeys.userProfileBanner.rawValue) {
//            bannerImageView.image = store.getImage(forKey: profileBannerImage as! String)
//        }
//    }
    
    
    // MARK: - Action-Functions --------------------------------------------------
    @IBAction func singlePlayerButtonTapped(_ sender: UIButton) {
        let labelText = sender.titleLabel?.text
        wantedTableView = labelText!
        profileTableView.reloadData()
    }
    
    
    @IBAction func multiPlayerButtonTapped(_ sender: UIButton) {
        let labelText = sender.titleLabel?.text
        wantedTableView = labelText!
        profileTableView.reloadData()
    }
    
    
    @IBAction func userNameTextfieldPressed(_ sender: UITextField) {
        userNameTextField.text = sender.text
        appDelegate.settings["userName"] = sender.text
        //store.set(sender.text, forKey: UserDefaults.UserDefaultKeys.userName.rawValue)
        sender.resignFirstResponder()
    }
    
    
    
    //MARK: - ImagePicker-Functions --------------------------------------------------
    
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
            // Hier Banner im Store speichern
            //store.setImage(image: image, forKey: UserDefaults.UserDefaultKeys.userProfileBanner.rawValue)
        } else if tapedImageView == avatarImageView {
            tapedImageView?.image = ProfileImageMaker.imageMaker.createProfileImage(from: image, favoriteColor: .yellow, radius: avatarImageView.frame.width/2)
            // Hier Avatar im Store speichern
            //store.setImage(image: image, forKey: UserDefaults.UserDefaultKeys.userProfileImage.rawValue)
        }
        //tapedImageView?.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table View Functions --------------------------------------------------
    
    let data = [
        CollapseableViewModel(label: "Account", image: #imageLiteral(resourceName: "blizzard"), children: [
            CollapseableViewModel(label: "Profile"),
            CollapseableViewModel(label: "Activate Account"),
            CollapseableViewModel(label: "Change Password")]),
        CollapseableViewModel(label: "Group"),
        CollapseableViewModel(label: "Events", image: nil, children: [
            CollapseableViewModel(label: "Nearby"),
            CollapseableViewModel(label: "Global"),
            ]),
        CollapseableViewModel(label: "Deals")
    ]
    
    var displayedRows : [CollapseableViewModel] = []
    
    
    // MARK: Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if wantedTableView == "Singleplayer" {
            return (demoData[wantedTableView]?.count)!
        } else {
            return displayedRows.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData : String
        tableView.separatorStyle = .none
        
        if wantedTableView == "Singleplayer" {
            let cell = profileTableView.dequeueReusableCell(withIdentifier: "SinglePlayerCell", for: indexPath) as! SinglePlayerCellController
            cellData = singlePlayerDemoData[indexPath.row]
            cell.gameNameLabel.text = cellData
            cell.gameScoreLabel.text = cellData
            return cell
        } else {
            //let cell = (tableView.dequeueReusableCell(withIdentifier: "MultiPlayerCell", for: indexPath) as? CollapsableTableViewCell) ?? CollapsableTableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell")
//            let cell = (UITableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell") as? CollapsableTableViewCell) ?? CollapsableTableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell") 
//            let viewModel = displayedRows[indexPath.row]
//            cell.textLabel?.text = viewModel.label
//            return cell
            
            let cell = (UITableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell") as? CollapsableTableViewCell) ?? CollapsableTableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell")
            //cell.layer.backgroundColor = UIColor.blue as? CGColor
            cell.configure(viewModel: displayedRows[indexPath.row])
            return cell
        }
        
//        let cell = (tableView.dequeueReusableCell(withIdentifier: "MultiPlayerCell", for: indexPath) as? CollapsableTableViewCell) ?? CollapsableTableViewCell(style: .default, reuseIdentifier: "MultiPlayerCell")
//        let viewModel = displayedRows[indexPath.row]
//        cell.textLabel?.text = viewModel.label
//        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let viewModel = displayedRows[indexPath.row]
        
        if viewModel.children.count > 0 {
            let range = indexPath.row+1...indexPath.row+viewModel.children.count
            let indexPaths = range.map{return NSIndexPath(row: $0, section: indexPath.section)}
            tableView.beginUpdates()
            
            if viewModel.isCollapsed {
                displayedRows.insert(contentsOf: viewModel.children, at: indexPath.row+1)
                tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
            } else {
                displayedRows.removeSubrange(range)
                tableView.deleteRows(at: indexPaths as [IndexPath], with: .automatic)
            }
            tableView.endUpdates()
        }
        viewModel.isCollapsed = !viewModel.isCollapsed
    }
    
    
}
