//
//  SubscriptionSplashViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class SubscriptionSplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func btnOnTry(_ sender: Any) {
        self.pushVc(viewConterlerId: "LoginViewController")
    }
    

    @IBAction func btnOnSubscribe(_ sender: Any) {
        
    }
}
