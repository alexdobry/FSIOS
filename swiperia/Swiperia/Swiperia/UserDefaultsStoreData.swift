//
//  UserDefaultsStoreData.swift
//  Swiperia
//
//  Created by Edgar Gellert on 20.09.17.
//  Copyright © 2017 Dennis Dubbert. All rights reserved.
//

import Foundation

// MARK: - Extension for UserDefaults
extension UserDefaults {
    
    enum UserDefaultKeys: String {
        case userName
        case userProfileImage
        case userProfileBanner
        case profileData
        case settingsData
        case singlePlayerData
        case multiPlayerData
    }
    
    // MARK: - Extension Functions
    // Dictionary zu Data
    func setData(dictionaryData: [String:Any], forKey key: String) {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dictionaryData)
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getData(forKey key: String) -> [String:Any] {
        var dictionary = Dictionary<String, Any>()
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            //let dictionary : Dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: Any]
            dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: Any]
            return dictionary
        }
        return dictionary
    }
    
    // Einzelne Datentypen speichern
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        print("ColorData : \(String(describing: colorData))")
        set(colorData, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getColor(forKey key: String) -> UIColor {
        var color : UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color!
    }
    
    func setImage(image: UIImage?, forKey key: String) {
        let imageString = imageToBase64(wantedImage: image!)
        UserDefaults.standard.set(imageString, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getImage(forKey key: String) -> UIImage {
        let image : UIImage = fromBase64ToImage(baseString: key)
        return image
    }
    
    
    
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: - Encoding and Decoding Functions for UIImage
    private func imageToBase64(wantedImage: UIImage) -> String {
        let image : UIImage = wantedImage
        let imageData : NSData = UIImagePNGRepresentation(image)! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    private func fromBase64ToImage(baseString: String) -> UIImage {
        let dataDecoded : NSData = NSData(base64Encoded: baseString, options: .ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataDecoded as Data)!
        return decodedImage
    }
 

}
