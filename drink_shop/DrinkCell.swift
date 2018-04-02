//
//  DrinkCell.swift
//  drink_shop
//
//  Created by Basel on 2018-03-28.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class DrinkCell: UICollectionViewCell {
    var image: UIImageView = {
       let imageView = UIImageView()
       return imageView
    }()
    var cellPadding: CGFloat?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        cellPadding = 10
        if  let padding = cellPadding {
            var top = image.topAnchor.constraint(equalTo: topAnchor, constant: padding)
            var bottom = image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
            var left = image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            var right = image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            NSLayoutConstraint.activate([top, bottom, left, right])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
