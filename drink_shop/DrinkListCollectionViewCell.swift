//
//  DrinkListCollectionViewCell.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class DrinkListCollectionViewCell: UICollectionViewCell {
    var image: UIImageView? = nil
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let img = image {
            self.addSubview(img)
            img.widthAnchor.constraint(equalTo: widthAnchor)
            img.heightAnchor.constraint(equalTo: heightAnchor)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
