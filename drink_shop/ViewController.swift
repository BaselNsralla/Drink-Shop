//
//  ViewController.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let drink = DrinkContainer()
    let orderButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 204/255, green: 102/255, blue: 153/255,alpha:1)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize.zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowPath = UIBezierPath(rect: btn.bounds).cgPath
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ORDER", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleShadowColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(drink)
        view.addSubview(orderButton)
        drink.translatesAutoresizingMaskIntoConstraints = false
        drink.heightAnchor.constraint(equalToConstant: CGFloat(350)).isActive = true
        drink.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        drink.backgroundColor = UIColor(red: 204/255, green: 102/255, blue: 153/255,alpha:1)
        drink.layer.shadowColor = UIColor.black.cgColor
        drink.layer.shadowOpacity = 1
        drink.layer.shadowOffset = CGSize.zero
        drink.layer.shadowRadius = 10
        drink.layer.shadowPath = UIBezierPath(rect: drink.bounds).cgPath
        
        orderButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        orderButton.topAnchor.constraint(equalTo: drink.bottomAnchor, constant: 10).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


