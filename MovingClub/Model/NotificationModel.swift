//
//  NotificationModel.swift
//  Culturally Yours App
//
//  Created by Rohit SIngh Dhakad on 29/04/25.
//

import UIKit

class NotificationModel: NSObject {
    
    var id: String?
    var user_id: String?
    var notification_type: String?
    var assignment_date: String?
    var start_time: String?
    var message: String?
    var created_at: String?
    var comment: String?
    var post_id: String?
    var rating: String?
    var review: String?
    var status: Int?
    var vote_scale: String?
    var mission_type: String?
    var client_address: String?
    var str_Duration:String?
    var confirmation_status:String?
    var mission_status:String?
    var strMissionID:String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["id"] as? Int {
            id = "\(value)"
        } else if let value = dictionary["id"] as? String {
            id = value
        }

        if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        } else if let value = dictionary["user_id"] as? String {
            user_id = value
        }

        if let value = dictionary["confirmation_status"] as? String {
            confirmation_status = value
        }
        
        if let value = dictionary["message"] as? String {
            message = value
        }

        if let value = dictionary["notification_type"] as? String {
            notification_type = value
        }

        if let value = dictionary["created_at"] as? String {
            created_at = value
        }

        if let value = dictionary["comment"] as? String {
            comment = value
        }

        if let value = dictionary["post_id"] as? Int {
            post_id = "\(value)"
        } else if let value = dictionary["post_id"] as? String {
            post_id = value
        }

        if let value = dictionary["rating"] as? String {
            rating = value
        }

        if let value = dictionary["review"] as? String {
            review = value
        }

        if let value = dictionary["status"] as? Int {
            status = value
        }

        if let value = dictionary["vote_scale"] as? String {
            vote_scale = value
        }

        if let missionDetail = dictionary["mission_detail"] as? [String: Any] {
            if let value = missionDetail["assignment_date"] as? String {
                assignment_date = value
            }
            if let value = missionDetail["start_time"] as? String {
                start_time = value
            }
            if let value = missionDetail["mission_type"] as? String {
                mission_type = value
            }
            if let value = missionDetail["mission_status"] as? String {
                mission_status = value
            }
            if let value = missionDetail["client_address"] as? String {
                client_address = value
            }
            if let value = missionDetail["mission_id"] as? String {
                strMissionID = value
            }
            if let value = missionDetail["duration"] as? String {
                str_Duration = value
            }
        }
    }
}

