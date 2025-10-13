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
    
    private let genderOptions = ["Male", "Female"]
    private var selectedGender: String?
    private var genderPicker = UIPickerView()
    
    private var isLoginScreen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginUI()
        setupGenderPicker()
    }
    
    private func setupGenderPicker() {
           genderPicker.delegate = self
           genderPicker.dataSource = self
           tfGender.inputView = genderPicker
           
           // Add a toolbar with Done button
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelectingGender))
           toolbar.setItems([doneButton], animated: true)
           tfGender.inputAccessoryView = toolbar
       }
       
       @objc private func doneSelectingGender() {
           if selectedGender == nil {
               selectedGender = genderOptions[0] // Default first option
               tfGender.text = selectedGender
           }
           tfGender.resignFirstResponder()
       }
    
    func setupLoginUI() {
        isLoginScreen = true
        self.vwFirstname.isHidden = true
        self.vwGender.isHidden = true
        self.clearFields()
        self.lblAlreadyHaveAnaccount.text = "Do you have an account? REGISTER"
        self.lblLogin.text = "LOGIN"
    }
    
    func setupRegistrationUI() {
        isLoginScreen = false
        self.vwFirstname.isHidden = false
        self.vwGender.isHidden = false
        self.clearFields()
        self.lblLogin.text = "REGISTER"
        self.lblAlreadyHaveAnaccount.text = "Already have an account? LOGIN"
    }
    
    private func clearFields() {
        self.tfEmail.text = ""
        self.tfFirstName.text = ""
        self.tfLastName.text = ""
        self.tfPassword.text = ""
        self.tfGender.text = ""
    }
    
    @IBAction func btnOnContinue(_ sender: UIButton) {
        if isLoginScreen {
            if validateLoginForm() {
                call_Websercice_Login()
            }
        } else {
            if validateSignupForm() {
                call_Webservice_Signup()
            }
        }
    }
    
    @IBAction func btnOnRegister(_ sender: Any) {
        let isLogin = vwFirstname.isHidden
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            if isLogin {
                self.setupRegistrationUI()
            } else {
                self.setupLoginUI()
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = genderOptions[row]
        tfGender.text = selectedGender
    }
}


extension LoginViewController {
    
    
    
      func call_Websercice_Login() {
          guard objWebServiceManager.isNetworkAvailable() else {
              objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
              return
          }
          
          objWebServiceManager.showIndicator()
          
          let dictParam: [String: Any] = [
              "email": self.tfEmail.text ?? "",
              "password": self.tfPassword.text ?? "",
              "device_type": "iOS",
              "register_id": objAppShareData.strFirebaseToken
          ]
          
          objWebServiceManager.requestPost(
              strURL: WsUrl.url_LogIn,
              queryParams: [:],
              params: dictParam,
              strCustomValidation: "",
              showIndicator: false
          ) { response in
              objWebServiceManager.hideIndicator()
              
              let status = response["status"] as? Int
              let message = response["message"] as? String
              
              if status == MessageConstant.k_StatusCode {
                  if let result = response["result"] as? [String: Any] {
                      objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: result)
                      objAppShareData.fetchUserInfoFromAppshareData()
                      self.setRootController()
                  }
              } else {
                  objAlert.showAlert(message: message ?? "Something went wrong", title: "Alert", controller: self)
              }
          } failure: { error in
              objWebServiceManager.hideIndicator()
              print("Error: \(error)")
          }
      }
    
    
    //MARK: Sig Up Api Call
    
    func call_Webservice_Signup() {
           guard objWebServiceManager.isNetworkAvailable() else {
               objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
               return
           }
           
           objWebServiceManager.showIndicator()
           
           let dictParam: [String: Any] = [
               "first_name": self.tfFirstName.text ?? "",
               "last_name": self.tfLastName.text ?? "",
               "email": self.tfEmail.text ?? "",
               "password": self.tfPassword.text ?? "",
               "gender": self.tfGender.text ?? "",
               "device_type": "iOS",
               "register_id": objAppShareData.strFirebaseToken
           ]
           
           objWebServiceManager.requestPost(
               strURL: WsUrl.uel_SignUp,
               queryParams: [:],
               params: dictParam,
               strCustomValidation: "",
               showIndicator: false
           ) { response in
               objWebServiceManager.hideIndicator()
               
               let status = response["status"] as? Int
               let message = response["message"] as? String
               
               if status == MessageConstant.k_StatusCode {
                   if let result = response["result"] as? [String: Any] {
                       objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: result)
                       objAppShareData.fetchUserInfoFromAppshareData()
                       self.setRootController()
                   }
               } else {
                   objAlert.showAlert(message: message ?? "Something went wrong", title: "Alert", controller: self)
               }
           } failure: { error in
               objWebServiceManager.hideIndicator()
               print("Error: \(error)")
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


//MARK: Validations

extension LoginViewController {
    
    func validateLoginForm() -> Bool {
        guard let email = tfEmail.text, !email.isEmpty else {
            objAlert.showAlert(message: "Please enter email", title: "Alert", controller: self)
            return false
        }
        guard isValidEmail(email) else {
            objAlert.showAlert(message: "Please enter valid email", title: "Alert", controller: self)
            return false
        }
        guard let password = tfPassword.text, !password.isEmpty else {
            objAlert.showAlert(message: "Please enter password", title: "Alert", controller: self)
            return false
        }
        if password.count < 6 {
            objAlert.showAlert(message: "Password must be at least 6 characters", title: "Alert", controller: self)
            return false
        }
        return true
    }
    
    func validateSignupForm() -> Bool {
        guard let firstName = tfFirstName.text, !firstName.isEmpty else {
            objAlert.showAlert(message: "Please enter first name", title: "Alert", controller: self)
            return false
        }
        guard let lastName = tfLastName.text, !lastName.isEmpty else {
            objAlert.showAlert(message: "Please enter last name", title: "Alert", controller: self)
            return false
        }
        guard let email = tfEmail.text, !email.isEmpty else {
            objAlert.showAlert(message: "Please enter email", title: "Alert", controller: self)
            return false
        }
        guard isValidEmail(email) else {
            objAlert.showAlert(message: "Please enter valid email", title: "Alert", controller: self)
            return false
        }
        guard let password = tfPassword.text, !password.isEmpty else {
            objAlert.showAlert(message: "Please enter password", title: "Alert", controller: self)
            return false
        }
        if password.count < 6 {
            objAlert.showAlert(message: "Password must be at least 6 characters", title: "Alert", controller: self)
            return false
        }
        guard let gender = tfGender.text, !gender.isEmpty else {
            objAlert.showAlert(message: "Please enter gender", title: "Alert", controller: self)
            return false
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
}
