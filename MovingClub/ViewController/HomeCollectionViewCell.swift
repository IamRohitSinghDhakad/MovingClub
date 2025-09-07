//
//  HomeCollectionViewCell.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var imgvw: UIImageView!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var imgVwCheckBox: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            lbltitle.font = UIFont(name: "CenturyGothic", size: 12)
    }
}
