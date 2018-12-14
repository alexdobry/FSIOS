//: Playground - noun: a place where people can play

import UIKit

extension NSNotification.Name { // create own topic of type 'Notification.Name'
    static let MyModelDidChange = Notification.Name("MyModelDidChange")
}

struct MyModel {
    
    func modelHasChanged(to data: Data) {
        NotificationCenter.default.post( // post (broadcast) notification
            name: NSNotification.Name.MyModelDidChange, // under which topic to broadcast
            object: self, // sender
            userInfo: ["DataKey": data] // payload, accessible by 'DataKey'
        )
    }
}

class SomeViewController: UIViewController {
    
    var observer: NSObjectProtocol? // 'cookie' of observation. used for unobserving when finished
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        observer = NotificationCenter.default.addObserver(
            forName: .MyModelDidChange, // topic to observe for
            object: nil, // who should be the sender. nil for 'anyone'
            queue: OperationQueue.main, // queue where the following closure should be executed on. nil for 'same queue as sender'
            using: { notification in
                let data = notification.userInfo?["DataKey"] as? Data
                print(data ?? "no data")
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(observer!) // remove observation to prevent memory leaks
    }
}

class TargetActionViewController: UIViewController {
    
    let button: UIButton = UIButton() // code version of IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addTarget( // code version of 'crtl-drag' from storyboard to viewController
            self, // target
            action: #selector(buttonTapped(_:)), // function which will be executed
            for: .touchUpInside // action which will fire
        )
    }
    
    @objc func buttonTapped(_ sender: UIButton) { // code version of IBAction
        print("button tapped by target action")
    }
}

class MyTableViewController: UIViewController, UITableViewDataSource { // we have to implement 'UITableViewDataSource'
    
    let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self // make 'self' respond to 'tableView'. thus, tableView will now called certain functions which 'self' can implement
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // hey dataSource, how many sections?
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "row: \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section: \(section)"
    }
}

protocol NetworkClientDelegate {
    func networkClientDidStartDownloading()
    func networkClientDidFinishDownloading()
    func networkClientSucceeded(with data: Data)
    func networkClientFailed(with error: Error)
}

class NetworkClient {
    
    var delegate: NetworkClientDelegate? // anyone who is interested in can set himself as a delegate
    
    func download() { // 'NetworkClient' will talk to his delegate (if set) whenever something happens
        delegate?.networkClientDidStartDownloading() // hey delegate, i did start downloading. do something if you will
        // downloading ....
        delegate?.networkClientDidFinishDownloading() // hey delegate, i finished downloading. do something if you will
        
        let error: Error? = nil // suppose there is no error ...
        let data: Data = Data() // ... but data
        
        if let error = error {
            delegate?.networkClientFailed(with: error) // hey delegate, an error occurred. do something if you will
        } else {
            delegate?.networkClientSucceeded(with: data) // hey delegate, there is your result. do something if you will
        }
    }
}

class DownloadViewController: UIViewController, NetworkClientDelegate {
    
    let networkClient = NetworkClient()
    let spinner = UIActivityIndicatorView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkClient.delegate = self // set my'self' to networkClient's delegate. i will get the calls now
        networkClient.download()
    }
    
    // have to implement them now ...
    func networkClientDidStartDownloading() {
        spinner.startAnimating() // show activity spinner when download starts
    }
    
    func networkClientDidFinishDownloading() {
        spinner.hidesWhenStopped = true
        spinner.stopAnimating() // hide activity spinner when download ends
    }
    
    func networkClientSucceeded(with data: Data) {
        label.text = String(describing: data)
    }
    
    func networkClientFailed(with error: Error) {
        print("show alert with \(error)")
    }
}
