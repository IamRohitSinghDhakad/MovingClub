//
//  WebServiceHelper.swift
//  Somi
//
//  Created by Paras on 24/03/21.
//

import Foundation
import UIKit



//let BASE_URL = "https://cyinterpreting.app/index.php/api/"//Live
//let BASE_URL_Image = "https://bhe.it.com/uploads/user/"
let BASE_URL = "https://ambitious.in.net/Shubham/movingClub/index.php/api/"//Local

//?email=ikdemo87@gmail.com&password=Abc@1234?
struct WsUrl{
    
    static let url_LogIn  = BASE_URL + "login"
    static let uel_SignUp = BASE_URL + "signup"
    static let url_ForgotPassword = BASE_URL + "forgot_password"
    static let url_getUserProfile  = BASE_URL + "get_profile"
    static let url_getCategory  = BASE_URL + "get_category"
    static let url_getVideo  = BASE_URL + "get_video"
    static let url_addComment  = BASE_URL + "add_comment"
    static let url_addDocument  = BASE_URL + "add_document"
    static let url_getNotification  = BASE_URL + "get_notifications?login_user_id="
    static let url_getConfirmationStatus  = BASE_URL + "update_confirmation_status"
    static let url_extendMissionTime  = BASE_URL + "extend_time"
   
}


//Api Header

struct WsHeader {

    //Login

    static let deviceId = "Device-Id"

    static let deviceType = "Device-Type"

    static let deviceTimeZone = "Device-Timezone"

    static let ContentType = "Content-Type"

}



//Api check for params
struct WsParamsType {
    static let PathVariable = "Path Variable"
    static let QueryParams = "Query Params"
}

