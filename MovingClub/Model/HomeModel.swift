//
//  HomeModel.swift
//  Culturally Yours App
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 26/04/25.
//

import UIKit

class HomeModel: NSObject {
    
    var mission_id: String?
    var user_id: String?
    var language: String?
    var assignment_date: String?
    var start_time: String?
    var end_time:String?
    var client_name: String?
    var client_address: String?
    var lep_name: String?
    var descriptionField: String?
    var status: String?
    var entrydt: String?
    var updatedt: String?
    var time_ago: String?
    var strClientLocation : String?
    var strMissionType : String?
    var strduration : String?
    var strInvoice_url : String?
    var strMileage : String?
    var strMileageUnit : String?
    var comments: [CommentModel] = []
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["mission_id"] as? String {
            mission_id = value
        } else if let value = dictionary["mission_id"] as? Int {
            mission_id = "\(value)"
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
        
        if let value = dictionary["language"] as? String {
            language = value
        }
        
        if let value = dictionary["mission_type"] as? String {
            strMissionType = value
        }
        
        if let value = dictionary["client_address"] as? String {
            strClientLocation = value
        }
        
        if let value = dictionary["assignment_date"] as? String {
            assignment_date = value
        }
        
        if let value = dictionary["start_time"] as? String {
            start_time = value
        }
        
        if let value = dictionary["end_time"] as? String {
            end_time = value
        }
        
        
        if let value = dictionary["client_name"] as? String {
            client_name = value
        }
        
        if let value = dictionary["client_address"] as? String {
            client_address = value
        }
        
        if let value = dictionary["lep_name"] as? String {
            lep_name = value
        }
        
        if let value = dictionary["description"] as? String {
            descriptionField = value
        }
        
        if let value = dictionary["status"] as? String {
            status = value
        }
        
        if let value = dictionary["invoice_url"] as? String {
            strInvoice_url = value
        }
        
        if let value = dictionary["entrydt"] as? String {
            entrydt = value
        }
        
        if let value = dictionary["updatedt"] as? String {
            updatedt = value
        }
        
        if let value = dictionary["time_ago"] as? String {
            time_ago = value
        }
        
        if let value = dictionary["duration"] as? String {
            strduration = value
        }
        
        if let value = dictionary["duration"] as? String {
            strduration = value
        }
        
        if let value = dictionary["mileage"] {
            if let doubleValue = value as? Double {
                strMileage = String(doubleValue)
            } else if let stringValue = value as? String {
                strMileage = stringValue
            }
        }

        if let value = dictionary["mileage_unit"] as? String {
            strMileageUnit = value
        }
        
        if let commentArray = dictionary["comments"] as? [[String: Any]] {
            for dict in commentArray {
                let comment = CommentModel(from: dict)
                comments.append(comment)
            }
        }
    }
}
class CommentModel: NSObject {
    
    var comment: String?
    var comment_id: String?
    var entrydt: String?
    var mission_id: String?
    var updatedt: String?
    var user_id: String?
    var time_ago: String?
    var user_image: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["comment"] as? String {
            comment = value
        }
        
        if let value = dictionary["comment_id"] as? String {
            comment_id = value
        } else if let value = dictionary["comment_id"] as? Int {
            comment_id = "\(value)"
        }
        
        if let value = dictionary["entrydt"] as? String {
            entrydt = value
        }
        
        if let value = dictionary["mission_id"] as? String {
            mission_id = value
        } else if let value = dictionary["mission_id"] as? Int {
            mission_id = "\(value)"
        }
        
        if let value = dictionary["updatedt"] as? String {
            updatedt = value
        }
        
        if let value = dictionary["time_ago"] as? String {
            time_ago = value
        }
        
        if let value = dictionary["user_image"] as? String {
            user_image = value
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
    }
}
