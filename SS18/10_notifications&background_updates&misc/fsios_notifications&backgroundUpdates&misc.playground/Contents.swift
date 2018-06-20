//: Playground - noun: a place where people can play

import UIKit

class ViewController: UIViewController {
    
    struct ScheduleAlertStrings {
        static let Title = ""
        static let Message = ""
        static let DownloadButton = ""
        static let ContinueButton = ""
        static let CancelButton = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alert = UIAlertController(
            title: ScheduleAlertStrings.Title,
            message: ScheduleAlertStrings.Message,
            preferredStyle: .actionSheet // alert style
        )
        
        alert.addAction(UIAlertAction(
            title: ScheduleAlertStrings.DownloadButton,
            style: .default,
            handler: { action in self.downloadAll() })
        )
        
        alert.addAction(UIAlertAction(
            title: ScheduleAlertStrings.ContinueButton,
            style: .default,
            handler: { action in self.addEntry() })
        )
        
        alert.addAction(UIAlertAction(
            title: ScheduleAlertStrings.CancelButton,
            style: .cancel,
            handler: nil)
        )
        
        // enable iPad support
        alert.modalPresentationStyle = .popover
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func downloadAll() {}
    private func addEntry() {}
}

import UserNotifications // import is required
import CoreLocation

struct Model: Codable { }

class NotificationService {
    
    // register user notification (both local and remote)
    static func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            // this closure will be executed off the main queue
            
            if let error = error {
                debugPrint(#function, error.localizedDescription)
            }
            
            DispatchQueue.main.async { // thus we have to dispatch back on main queue
                completion(granted)
            }
        }
    }
    
    static func notificationContent(with model: Model) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "New Data Available!"
        content.subtitle = "we are happy to announce new stuff"
        content.badge = 1 // number to appear on app icon
        content.sound = .default()
        content.userInfo = [
            "Payload": try! PropertyListEncoder().encode(model) // value must be a property list
        ]
        
        return content
    }
    
    static func schedule(notification: UNNotificationContent, at trigger: UNNotificationTrigger?) {
        let uniqueString = String(Date().timeIntervalSince1970)
        let request = UNNotificationRequest(
            identifier: uniqueString, // id of notification... create a new request each time
            content: notification,
            trigger: trigger // nil means 'fire immediately'
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil) // schedule notification request
    }
    
    // MARK: - Interval
    
    static func inFiveMinutes() -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 60 * 5, repeats: false)
    }
    
    static func everyMinute() -> UNTimeIntervalNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    }
    
    // MARK: - Calender
    
    static func atBithday() -> UNCalendarNotificationTrigger {
        var comps = DateComponents()
        comps.year = 2018
        comps.month = 3
        comps.day = 16
        comps.hour = 18
        comps.minute = 33
        
        return UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
    }
    
    // MARK: - Location
    
    static func whenArrivingAtCampusGummersbach() -> UNLocationNotificationTrigger {
        let center = CLLocationCoordinate2D(latitude: 51.0232, longitude: 7.5621) // see `import CoreLocation`
        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "THK - Campus Gummersbach")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        return UNLocationNotificationTrigger(region: region, repeats: false)
    }
    
    static func removeAll() {
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        center.removeDeliveredNotifications(withIdentifiers: ["first"])
        center.removePendingNotificationRequests(withIdentifiers: ["second"])

        let identifier = "same identifier"
        let content = UNNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: true)
        
        let req = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(req, withCompletionHandler: nil)
        
        // later on … something changed
        let updatedReq = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(updatedReq, withCompletionHandler: nil) // update existing notification, whether delivered or pending
    }
    
    static let center = UNUserNotificationCenter.current()
    
    static func remove(by identifiers: [String]) {
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    // identifier has to be the same
    static func update(by identifier: String, withNewContent content: UNNotificationContent, andNewTrigger trigger: UNNotificationTrigger) {
        // later on … something changed
        let updatedReq = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(updatedReq, withCompletionHandler: nil) // update existing notification, whether delivered or pending
    }
    
    static func notificatonWithActions() {
        let content = UNMutableNotificationContent()
        content.title = "House Alarm"
        content.subtitle = "Someone is in front of your door"
        
        let catIdentifier = "Default House Alarm" // identifier of associated actions
        let openDoor = UNNotificationAction(identifier: "open", title: "open the door", options: .authenticationRequired) // unlock device before being performed
        let silenceAlarm = UNNotificationAction(identifier: "silence", title: "stop alarm", options: [.destructive, .authenticationRequired]) // unlock device and it is destructive
        let showCamera = UNNotificationAction(identifier: "camera", title: "show camera", options: .foreground) // launch the app in the foreground due to camera view controller
        
        let category = UNNotificationCategory(identifier: catIdentifier, actions: [openDoor, silenceAlarm, showCamera], intentIdentifiers: [], options: []) // bind actions with category
        content.categoryIdentifier = catIdentifier // bind category with content
        
        center.setNotificationCategories([category]) // register category
        center.add(UNNotificationRequest(identifier: String(Date().timeIntervalSince1970), content: content, trigger: nil), withCompletionHandler: nil)
    }
}

// @UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self // assign delegate to self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint(#function, "with action:", response.actionIdentifier)
        
        if let data = response.notification.request.content.userInfo.first as? Data {
            // do something with data...
        }
        
        completionHandler() // need to be called
    }
    
    // called when a notification is delivered to a foreground app
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([]) // empty options means ‘dont show while app is in foreground’
    }
}

class Downloader {
    static func download(f: (String?) -> Void) { f(nil) }
}

// @UIApplicationMain
class AppDelegate2: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // specifies the minimum amount of time that must elapse between background fetch operations (default is never)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        return true
    }
    
    // tells the app that it can begin a fetch operation if it has data to download.
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // your app has up to 30 seconds of wall-clock time to perform the download operation
        print(application.backgroundTimeRemaining)
        
        Downloader.download { res in
            if let res = res {
                // do something with 'res' ...
                
                // must be called with a value that best describes the results of your download operation
                completionHandler(.newData)
            } else {
                // even with .noData or .failed
                completionHandler(.noData)
            }
        }
    }
}
