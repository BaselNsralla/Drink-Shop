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
    var deleteDelegate: DeleteDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(image)
        //buildConstraints()
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
            image.transform = CGAffineTransform(rotationAngle: 0)
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panDrink(_ target: AnyObject?){
        let gesture = target as! UIPanGestureRecognizer
        let drink = gesture.view! as! DrinkCell
        let drinkList = drink.superview! as! UICollectionView
        let point = gesture.translation(in: drinkList)
        drink.image.center = CGPoint(x: drink.image.center.x, y:  drink.bounds.midY + point.y)
        let normPi = (CGFloat.pi/Constants.cellSize.height)
        let factor = point.y
        drink.image.transform = CGAffineTransform(rotationAngle: normPi * factor)
        if gesture.state == .ended {
            print(drink.image.bounds.midY, self.section)
            if  drink.image.center.y < drink.image.bounds.minY || drink.image.center.y > drink.image.bounds.maxY  {
                if  let delegate = deleteDelegate {
                    let endFlight: CGFloat =  drink.image.center.y < drink.image.bounds.minY ? -Constants.cellSize.height: 2*Constants.cellSize.height
                    UIView.animate(withDuration: 0.1, animations: {
                        drink.image.center = CGPoint(x:  drink.bounds.midX  , y: endFlight)
                        drink.image.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    }){ (_) in
                        delegate.deleteItem(at: IndexPath(row: 0, section: self.section!), list: drinkList)
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    drink.image.center = CGPoint(x:  drink.bounds.midX  , y: drink.bounds.midY)
                    drink.image.transform = CGAffineTransform(rotationAngle: 0)
                })
            }
        }
        print("SOMETHING MOVED")
    }
}
