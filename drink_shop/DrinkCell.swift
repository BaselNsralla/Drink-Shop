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
    var section: Int?
    var cellPadding: CGFloat?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(image)
        buildConstraints()
        image.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panDrink(_:)))
        addGestureRecognizer(gesture)
        
    }
    
    func buildConstraints() {
        cellPadding = 10
        if  let padding = cellPadding {
            let top = image.topAnchor.constraint(equalTo: topAnchor, constant: padding)
            let bottom = image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
            let left = image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            let right = image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
            NSLayoutConstraint.activate([top, bottom, left, right])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panDrink(_ target: AnyObject?){
        let sender = target as! UIPanGestureRecognizer
        let drink = sender.view! as! DrinkCell
        //drink.superview?.gestureRecognizers
        let drinkList = drink.superview!
        let point = sender.translation(in: drinkList)
        //let drinkLayout = drinkList.layoutAttributesForItem(at: IndexPath(row: 0, section: drink.section!))!
        drink.image.center = CGPoint(x: drink.image.center.x, y:  drink.bounds.midY + point.y)
        let normPi = (CGFloat.pi/Constants.cellSize.height)
        let factor = point.y
        drink.image.transform = CGAffineTransform(rotationAngle: normPi * factor)
        if sender.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                drink.image.center = CGPoint(x:  drink.bounds.midX  , y: drink.bounds.midY)
                drink.image.transform = CGAffineTransform(rotationAngle: 0)
            })
        }
        print("SOMETHING MOVED")
    }
}
