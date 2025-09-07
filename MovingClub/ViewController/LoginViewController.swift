//
//  LoginViewController.swift
//  MovingClub
//
//  Created by Rohit SIngh Dhakad on 06/09/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblAlreadyHaveAnaccount: UILabel!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var vwGender: UIView!
    @IBOutlet weak var vwFirstname: UIView!
    @IBOutlet weak var tfGender: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupLoginUI()
    }
    
    func setupLoginUI(){
        self.vwFirstname.isHidden = true
        self.vwGender.isHidden = true
        self.tfEmail.text = ""
        self.tfFirstName.text = ""
        self.tfLastName.text = ""
        self.tfPassword.text = ""
        self.tfGender.text = ""
        self.lblAlreadyHaveAnaccount.text = "Do you have an account? REGISTER"
        self.lblLogin.text = "LOGIN"
    }
    
    func setupRegistrationUI(){
        self.vwFirstname.isHidden = false
        self.vwGender.isHidden = false
        self.tfEmail.text = ""
        self.tfFirstName.text = ""
        self.tfLastName.text = ""
        self.tfPassword.text = ""
        self.tfGender.text = ""
        self.lblLogin.text = "Register"
        self.lblAlreadyHaveAnaccount.text = "Already have an account? LOGIN"
    }
    
    @IBAction func btnOnContinue(_ sender: UIButton) {
        self.call_Websercice_Login()
    }
    
    @IBAction func btnOnRegister(_ sender: Any) {
        let isLogin = vwFirstname.isHidden
          
          UIView.animate(withDuration: 0.3,
                         delay: 0,
                         options: .curveEaseOut,
                         animations: {
              if isLogin {
                  self.setupRegistrationUI()
                  self.view.layoutIfNeeded()
              } else {
                  self.setupLoginUI()
                  self.view.layoutIfNeeded()
              }
          }, completion: nil)
    }
}


extension LoginViewController {
    
    
    func call_Websercice_Login() {
    
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["email": self.tfEmail.text!, "password": self.tfPassword.text!,
                         "device_type": "iOS","register_id": objAppShareData.strFirebaseToken]as [String:Any]
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_LogIn, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [String: Any] {
                   
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: resultArray)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.setRootController()
                    
                }
            }else{
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
           
            
        }
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
