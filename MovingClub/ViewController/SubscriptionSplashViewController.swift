//
//  SubscriptionSplashViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class SubscriptionSplashViewController: UIViewController {

   
    @IBOutlet weak var lbl10Euro: UILabel!
    @IBOutlet weak var lblFor1Year: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.lbl10Euro.font = UIFont(name: "CenturyGothic-Bold", size: 18)
        self.lblFor1Year.font = UIFont(name: "CenturyGothic", size: 12)
        self.lbldescription.font = UIFont(name: "CenturyGothic-Bold", size: 18)
        
    }
    

    @IBAction func btnOnTry(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
    

    @IBAction func btnOnSubscribe(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
}
