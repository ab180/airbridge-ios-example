import UIKit
import AirBridge

class ViewController: UIViewController {
    @IBOutlet weak var trackEventButton: UIButton!
    @IBOutlet weak var navigateToWebViewButton: UIButton!
    
    @IBOutlet weak var reportAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportAlertLabel.alpha = 0
        trackEventButton.addTarget(nil, action: #selector(trackEvent), for: .touchUpInside)
    }

    @objc func trackEvent() {
        // MARK: Example In app event
        
        // For tracking specific in-app events, we can create a dictionary
        // representing the event's characteristics.
        // Here, we are tracking the details of two products, 'lipstick' and 'foundation'.
        
        let lipstick: [String: Any] = [
            ABProductKey.productID: "lipstick_red",
            ABProductKey.name: "Lipstick - Ruby Red",
            ABProductKey.quantity: 1,
            ABProductKey.currency: "USD",
            ABProductKey.price: 12.99,
            ABProductKey.position: 0
        ]
        
        let foundation: [String: Any] = [
            ABProductKey.productID: "foundation_light",
            ABProductKey.name: "Foundation - Light Shade",
            ABProductKey.quantity: 1,
            ABProductKey.currency: "USD",
            ABProductKey.price: 24.99,
            ABProductKey.position: 1
        ]
        
        guard let viewProductDetailEvent = ABInAppEvent() else { return }
        
        // 'semanticsDictionary' will include the products we are tracking
        let semanticsDictionary: [String: Any] = [
            ABSemanticsKey.products: [lipstick, foundation]
        ]
        
        // Set the category of the event
        viewProductDetailEvent.setCategory(ABCategory.viewProductDetail)
        
        // Provide the semantics (details) of the event
        viewProductDetailEvent.setSemantics(semanticsDictionary)
        
        // Send the event for tracking
        viewProductDetailEvent.send()
        
        presentAlertLabel()
    }

    /// Display an alert to the user after the event is sent
    private func presentAlertLabel() {
        UIView.animate(withDuration: 0.1) {
            self.reportAlertLabel.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.1) {
                self.reportAlertLabel.alpha = 0
            }
        }
    }
}
