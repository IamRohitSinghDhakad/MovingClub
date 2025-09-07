//
//  PrivacyPolicyViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var webVw: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = "Privacy Policy"
        lblHeader.font =  UIFont(name: "CenturyGothic-Bold", size: 20)
        webVw.navigationDelegate = self
        
        loadAboutPage()
    }
    
    private func loadAboutPage() {
        if let url = URL(string: BASE_URL + "PrivacyPolicy") {
            let request = URLRequest(url: url)
            webVw.load(request)
        } else {
            print("❌ Invalid About Us URL")
        }
    }

  
     @IBAction func btnSideMenu(_ sender: Any) {
         SideMenuManager.shared.showMenu(from: self)
     }
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("⏳ Loading started...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("✅ Finished loading About Us page.")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ Failed to load: \(error.localizedDescription)")
    }
    
    

}
