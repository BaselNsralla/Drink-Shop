//
//  DrinkListCollectionViewCell.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class DrinkListCollectionViewCell: UICollectionViewCell {
    var image: UIImageView? = nil {
        didSet {
            self.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            self.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let img = image {
            self.addSubview(img)
            img.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            img.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
