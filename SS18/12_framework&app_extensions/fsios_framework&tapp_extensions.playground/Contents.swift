//: Playground - noun: a place where people can play

import UIKit

let appGroupIdentifier = "group.de.fhkoeln.inf.adv.fsios.YourAppName"
let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
let sharedUserDefaults = UserDefaults(suiteName: appGroupIdentifier)

import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap))) // `view` should be tapable
    }
    
    @objc func onTap() {
        extensionContext?.open(URL(string: "MyAppScheme://?viewController=FirstViewController")!, completionHandler: nil) // remember to enable `MyAppScheme`
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded // enable "more" button
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) { // update your content here
        Network().go { result in
            if let result = result {
                updateUI(with: result)
                completionHandler(.newData) // remember to call completionHandler with .newData
            } else {
                completionHandler(.noData) // ... or with .noData
            }
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode { // which display mode are we currently on?
        case .expanded:
            let heightAfterExpanded = expandUI()
            self.preferredContentSize = CGSize(width: maxSize.width, height: heightAfterExpanded)
        case .compact:
            shrinkUI()
            self.preferredContentSize = maxSize
        }
    }
    
    private func shrinkUI() {}
    private func expandUI() -> CGFloat { return 0.0 }
    private func updateUI(with string: String?) {}
}

struct Network {
    func go(completion: (String?) -> Void) {}
}

// @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL, // MyAppScheme://?viewController=FirstViewController
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "MyAppScheme",
            let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems, // ?viewController=FirstViewController
            queryItems.first?.value == "FirstViewController" {
            launchFirstViewController()
            return true
        } else {
            return false
        }
    }
    
    private func launchFirstViewController() {}
}
