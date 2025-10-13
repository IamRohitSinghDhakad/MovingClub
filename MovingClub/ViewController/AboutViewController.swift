//
//  AboutViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit
import WebKit

class AboutViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var webKit: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeading.text = "About Us"
        lblHeading.font =  UIFont(name: "CenturyGothic-Bold", size: 20)
        webKit.navigationDelegate = self
        
        loadAboutPage()
    }
    
    private func loadAboutPage() {
        if let url = URL(string: BASE_URL + "page?page=About%20Us") {
            print(url)
            let request = URLRequest(url: url)
            webKit.load(request)
        } else {
            print("❌ Invalid About Us URL")
        }
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
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
