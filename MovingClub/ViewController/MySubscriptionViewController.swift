//
//  MySubscriptionViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class MySubscriptionViewController: UIViewController {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblYouAlreadyhave: UILabel!
    @IBOutlet weak var vwBtnSubscribe: UIView!
    
    
    let objUser :UserModel = UserModel(from: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.vwBtnSubscribe.isHidden = true
        self.lblYouAlreadyhave.isHidden = true
        self.lblPrice.text = "10 €"
        self.lblPrice.font = UIFont(name: "CenturyGothic-Bold", size: 25)
        self.lblYear.font = UIFont(name: "CenturyGothic", size: 25)
        
        self.call_Websercice_GetProfile()
    }
    
    @IBAction func btnSideMenu(_ sender: Any) {
        // Do login / register validation here
        SideMenuManager.shared.showMenu(from: self)
    }
    
    @IBAction func btnOnSubscribe(_ sender: Any) {
    }
    
    
}

extension MySubscriptionViewController{
    
    func call_Websercice_GetProfile() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["login_user_id": objAppShareData.UserDetail.strUserId ?? "0"]as [String:Any]
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [String: Any] {
                    let objuser = UserModel(from: resultArray)
                    
                    if objuser.is_plan_active == "1"{
                        self.vwBtnSubscribe.isHidden = true
                        self.lblYouAlreadyhave.isHidden = false
                    }else{
                        self.vwBtnSubscribe.isHidden = false
                        self.lblYouAlreadyhave.isHidden = true
                    }
                    
                }
            }else{
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
            
            
        }
    }
}
