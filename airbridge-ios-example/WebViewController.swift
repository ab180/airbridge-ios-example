import UIKit
import WebKit
import AirBridge

/// In this file, we will demonstrate how to set up a hybrid app configuration.
/// You can directly test the `trackEvent` method using our provided web page,
/// and this can also be checked in the Airbridge dashboard's App-realtime-log.
///
class WebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // This is the example web page we offer to test `trackEvent`.
        // Replace this with the URL of your own webpage in actual use.
        let url = URL(string: "https://ab180.github.io/airbridge-web-example/?app=exabr")!
        let request = URLRequest(url: url)

        webView.backgroundColor = .clear
        webView.load(request)
        
        let controller = webView.configuration.userContentController
        
        // AirBridge's web interface helps forwarding events from the web to the app.
        // This token is for the example web page.
        // Replace this with your app's webToken(not appToken) in actual use.
        AirBridge.webInterface()?.inject(to: controller, withWebToken: "caf7b7cede124b8fb7c0e7eff887c2cb")
    }
}
