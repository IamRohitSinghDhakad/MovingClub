//
//  HomeModel.swift
//  Culturally Yours App
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 26/04/25.
//

import UIKit

class CategoryModel: NSObject {
    
    var categoryID: String?
    var categoryName: String?
    var categoryImage: String?
    var sortOrder: Int?
    var status: Int?
    var entryDate: String?
    var isSelected: Bool = false
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["id"] as? Int {
            categoryID = "\(value)"
        } else if let value = dictionary["id"] as? String {
            categoryID = value
        }
        
        categoryName = dictionary["name"] as? String
        categoryImage = dictionary["image"] as? String
        
        if let value = dictionary["sort_order"] as? Int {
            sortOrder = value
        } else if let value = dictionary["sort_order"] as? String, let intVal = Int(value) {
            sortOrder = intVal
        }
        
        if let value = dictionary["status"] as? Int {
            status = value
        } else if let value = dictionary["status"] as? String, let intVal = Int(value) {
            status = intVal
        }
        
        entryDate = dictionary["entrydt"] as? String
    }
}



class VideoModel: NSObject {
    
    var videoID: String?
    var categoryIDs: [String]?
    var categoryNames: [String]?
    var entryDate: String?
    var isPlanActive: Bool?
    var sortOrder: Int?
    var status: Int?
    var thumbnailURL: String?
    var videoURL: String?
    var type: String?   // "Free" or "Paid"
    var isSelected: Bool = false
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        // id
        if let value = dictionary["id"] as? Int {
            videoID = "\(value)"
        } else if let value = dictionary["id"] as? String {
            videoID = value
        }
        
        // category_id → [String]
        if let catString = dictionary["category_id"] as? String {
            categoryIDs = catString.components(separatedBy: ",")
        }
        
        // category_names → [String]
        if let names = dictionary["category_names"] as? [String] {
            categoryNames = names
        }
        
        // entrydt
        if let value = dictionary["entrydt"] as? String {
            entryDate = value
        }
        
        // is_plan_active → Bool
        if let value = dictionary["is_plan_active"] as? Int {
            isPlanActive = (value == 1)
        } else if let value = dictionary["is_plan_active"] as? String,
                  let intVal = Int(value) {
            isPlanActive = (intVal == 1)
        }
        
        // sort_order
        if let value = dictionary["sort_order"] as? Int {
            sortOrder = value
        } else if let value = dictionary["sort_order"] as? String,
                  let intVal = Int(value) {
            sortOrder = intVal
        }
        
        // status
        if let value = dictionary["status"] as? Int {
            status = value
        } else if let value = dictionary["status"] as? String,
                  let intVal = Int(value) {
            status = intVal
        }
        
        // thumbnail
        if let value = dictionary["thumbnail"] as? String {
            thumbnailURL = value
        }
        
        // video
        if let value = dictionary["video"] as? String {
            videoURL = value
        }
        
        // type
        if let value = dictionary["type"] as? String {
            type = value
        }
    }
}
