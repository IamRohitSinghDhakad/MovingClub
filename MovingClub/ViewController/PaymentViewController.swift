//
//  PaymentViewController.swift
//  MovingClub
//
//  Created by Rohit SIngh Dhakad on 18/11/25.
//

import UIKit
import WebKit

protocol MakePaymentDelegate: AnyObject {
    func paymentDidComplete(success: Bool)
}

class PaymentViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webVw: WKWebView!
    
    weak var delegate: MakePaymentDelegate?
    var strAmount = "10"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadPaymentPage()
    }
    
    private func loadPaymentPage() {
        if let url = URL(string: "https://ambitious.in.net/Shubham/movingClub/index.php/api/card_view?user_id=\(objAppShareData.UserDetail.strUserId ?? "0")&amount=\(strAmount)") {
            print(url)
            let request = URLRequest(url: url)
            webVw.load(request)
        } else {
            print("❌ Invalid About Us URL")
        }
    }
    
    // Handle Navigation Response
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let url = navigationResponse.response.url?.absoluteString {
            print(url)
            if url.contains("success") {  // Replace with actual success URL pattern
                handlePaymentSuccess()
            } else if url.contains("cancel") {  // Replace with actual cancel URL pattern
                handlePaymentCancel()
            }
        }
        decisionHandler(.allow)
    }
    
    private func handlePaymentSuccess() {
        let alert = UIAlertController(title: "Payment Successful", message: "Your payment has been processed successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.paymentDidComplete(success: true)  // Notify about success
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func handlePaymentCancel() {
        let alert = UIAlertController(title: "Payment Canceled", message: "Your payment was not completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.delegate?.paymentDidComplete(success: false)  // Notify about cancellation
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    

}
