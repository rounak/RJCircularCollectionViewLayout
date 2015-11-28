//
//  ImageViewCell.swift
//  RJCircularCollectionViewLayout
//
//  Created by Rounak Jain on 11/26/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import RJCircularCollectionViewLayout

class ImageViewCell: BaseCircularCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    let cornerRadius: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.layer.cornerRadius = cornerRadius
        self.imageView.layer.shouldRasterize = true
        self.imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.contentView.layer.shadowOffset = CGSize(width: -3, height: 0)
        self.contentView.layer.shadowOpacity = 0.7
        self.contentView.layer.shadowRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: cornerRadius).CGPath
    }

}
