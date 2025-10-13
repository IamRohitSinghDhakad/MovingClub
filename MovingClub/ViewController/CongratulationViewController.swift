//
//  CongratulationViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class CongratulationViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
    }
    @IBAction func btnGoHome(_ sender: Any) {
        setRootController()
    }
    

    func setRootController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.navigationBar.isHidden = true
        appDelegate.window?.rootViewController = navController
    }

}
