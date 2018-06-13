//: Playground - noun: a place where people can play

import UIKit

protocol Delegate: class {
    
}

class A: Delegate {
    var b: B?
    
    init() {
        self.b = B() // A -> B
        b?.delegate = self
    }
    
    deinit { debugPrint("A", #function) }
}

class B {
    weak var delegate: Delegate?
    
    deinit { debugPrint("A", #function) } // will no be called
}

struct Tweet { let text: String; let userImageUrl: String }

// downloads image from url in background and returns UIImage when finished
func downloadImage(by url: String, completion: (UIImage) -> ()) { /*fake download ... */ completion(UIImage()) }

class TweetCell: UITableViewCell {
    private let profileImageView = UIImageView()
    private let tweetTextLabel = UILabel()
    
    var tweet: Tweet? { didSet { updateUI(with: tweet!) } }
    
    private func updateUI(with tweet: Tweet) {
        tweetTextLabel.text = tweet.text
        
        downloadImage(by: tweet.userImageUrl, completion: { [weak self] image in // weak self is captured by the closure
            self?.profileImageView.image = image // self is optional now. if we (self) are in the heap, show the image, do nothing otherwise
        })
        
        // given we are on a bad internet connection but scrolling all the way down. images appear slowly and try to get displayed in `profileImageView`. what if we leave the TweetTableViewController because we want to send direct messages. our TweetTableViewController won't deinit, because some of his cells are still living in the heap. this happens because downloadImage's closure holds a strong reference to `self` while `self', aka the TweetCell, holds the closure
        // we need a strong pointer to the closure because we want to yield it's result some day. but we can pass a weak pointer of `self` to the closure to break the memory cycle. when the download completes, the cell (self) might be deallocated, which only happens if TweetTableViewController isn't on screen anymore. at this time we can't (and won't) see the profile picture anyway
    }
}

class ImageLoader {
    var imageView: UIImageView?
    
    func imageSync(by url: URL) {
        let data = try? Data(contentsOf: url) // bad! this line is blocking current (main) queue
        let img = data.flatMap(UIImage.init) // UIImage has an initializer which tries to build an image out of data
        
        imageView?.image = img
    }
    
    func imageAsync(by url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { // request global queue and run asynchronously
            let data = try? Data(contentsOf: url) // this line will now block another queue than main queue
            let image = data.flatMap(UIImage.init)
            
            DispatchQueue.main.async { // finished async task... request main queue and show result
                self.imageView?.image = image // again: 'imageView' is UI code. thus we need main queue
            }
        }
    }
}

class Webservice {
    
    var label: UILabel!
    
    func requestGET(url: URL) {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in // off main thread, managed by URLSession
            let mapped = data.map { d -> String in // do something with data … asynchronously
                return d.description
            }
            
            DispatchQueue.main.async { // super important: request main queue in order to update UI
                self.label.text = mapped
            }
        }
        
        // dataTask(with:) creates a task and returns immediately …
        
        task.resume() // thus we have to resume (aka. start) the task afterwards
    }
    
    func requestPOST(url: URL, body: [String: Any]) {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // off main thread, managed by URLSession
            // if we don't do anything on the main queue anyway, we don't need it either
        }
        
        task.resume() // still important
    }
}

/*struct Person: Codable {
    let name: String
    let birthDay: Date
}

/* JSON to parse
 [
    {
        "name": "alex",
        "birthDay": 634172400
    },
    {
        "name": "oskar",
        "birthDay": 1431986400
    },
    {
        "name": "anuschka",
        "birthDay": 1521158400
    }
 ]
*/

typealias JsonObject = [String: AnyObject]
typealias JsonArray = [JsonObject] // nice little trick

func parseJsonByHand(_ data: Data) -> [Person] { // manuel parsing
    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JsonArray // cast
    
    let persons: [Person]? = json??.flatMap { json -> Person? in // iterate through dict and try to build model
        guard let name = json["name"] as? String,
            let seconds = json["birthDay"] as? Int
        else { return nil }
        
        return Person(name: name, birthDay: Date(timeIntervalSince1970: TimeInterval(seconds)))
    }
    
    return persons ?? []
}

// extension Person: Codable { } // make your model conform to ‘Codable’

func parseJsonWithCodable(_ data: Data) -> [Person] {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970 // .iso8601, .formatted(dateFormatter), and much more
    
    let persons = try? decoder.decode([Person].self, from: data) // automatic conversion, error otherwise
    
    return persons ?? []
}
*/

/*/* JSON with nested objects
 [
    {
        "name": "alex",
        "birthDay": 634172400,
        "address": {
            "street": "steinmuellerallee 1",
            "zip_code": "51643",
            "city": "gummersbach"
        }
     },
     { ... },
     { ... }
 ]
*/

struct Person: Codable {
    let name: String
    let birthDay: Date
    let address: Address // nested type which needs to be `Codable` too
}

struct Address: Codable { // conform to `Codable`
    let street: String
    let city: String
    let zip_code: String
}*/


/* JSON with different attribute names
 [
     {
         ...
         "address": {
             "street": "steinmuellerallee 1",
             “zip_code": "51643",
             "city": "gummersbach"
        }
     },
     { ... },
     { ... }
 ]
 */

struct Address: Codable {
    let city: String; let zipCode: Int
    
    enum CodingKeys: String, CodingKey {
        /* case street */ // exclude street
        case zipCode = "zip_code"
        case city
    }
}

struct Person: Codable {
    /* ... */ let address: Address
}

/*struct Address: Codable {
    let city: String; let zipCode: Int // zipCode is now of type int
    
    enum CodingKeys: String, CodingKey { /* like from before */ }
}*/

extension Address {
    
    enum AddressCodableError: Error { // custom error
        case invalidCast(of: String)
    }
    
    init(from decoder: Decoder) throws { // override serialization
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let city = try container.decode(String.self, forKey: .city)
        let zip = try container.decode(String.self, forKey: .zipCode)
        
        if let zipCode = Int(zip) { // cast zipCode from String to Int
            self.init(city: city, zipCode: zipCode)
        } else {
            throw AddressCodableError.invalidCast(of: zip) // throw otherwise
        }
    }
    
    func encode(to encoder: Encoder) throws { // override deserialization
        var container = encoder.container(keyedBy: CodingKeys.self) // ‘container’ has to be mutable!
        try container.encode(city.lowercased(), forKey: .city) // lowercased also
        try container.encode(zipCode.description, forKey: .zipCode) // encode string
    }
}

let address = Address(city: "Gummersbach", zipCode: 51643)

do {
    let json: Data = try JSONEncoder().encode(address)
    let jsonString: String? = String(data: json, encoding: .utf8) // json is usually utf-8 encoded
    print("encoded json", jsonString)
    
    let addrrs: Address = try JSONDecoder().decode(Address.self, from: json)
    print("decoded address", addrrs)
} catch {
    print(error.localizedDescription)
}
