//
//  VideosByCategoryCollectionViewCell.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class VideosByCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var vwOuter: UIView!
    @IBOutlet weak var imgvw: UIImageView!
    @IBOutlet weak var imgvwCheckBox: UIImageView!
    @IBOutlet weak var imgvwToShowOnFull: UIImageView!
    @IBOutlet weak var vwLock: UIView!
    @IBOutlet weak var btnShowImage: UIButton!
    
    override func awakeFromNib() {
            super.awakeFromNib()
       // self.vwLock.isHidden = true
    }
}
