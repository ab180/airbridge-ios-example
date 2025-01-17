import UIKit
import AirBridge
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var observer: NSObject?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        // Initialize and get an Airbridge SDK instance
        // Replace with your actual `appToken` and `appName`
        AirBridge.getInstance("c3b61a44d8f74811b2f63857cfcd3a7f", appName: "exabr", withLaunchOptions:launchOptions)
        
        // Set the tracking authorize timeout in milliseconds
        AirBridge.setting().trackingAuthorizeTimeout = 60 * 1000
        
        // Set deeplink callback
        AirBridge.deeplink().setDeeplinkCallback { url in
            // This block will be executed once the deeplink has been processed
            // Here we present an alert with the received deeplink url
            DispatchQueue.main.async {
                guard let rootViewController = self.window?.rootViewController else { return }
                rootViewController.present(self.deeplinkAlertController(url: url), animated: true)
            }
        }
        
        // Request tracking authorization
        let observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { _ in }
            }
            if let observer = self?.observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        return true
    }
    
    // Handle URL scheme deeplinks
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // AirBridge handles the URL scheme deeplink and reports the information
        // through `handleURLSchemeDeeplink(_: URL)` method
        AirBridge.deeplink()?.handleURLSchemeDeeplink(url)
        
        return true
    }
    
    // Handle universal links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // AirBridge handles the universal link and reports the information
        // through `handle(_: NSUserActivity)` method
        AirBridge.deeplink()?.handle(userActivity)
        
        return true
    }
    
    private func deeplinkAlertController(url: String) -> UIAlertController {
        let alertController = UIAlertController(
            title: "Deeplink",
            message: url,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        return alertController
    }
}
