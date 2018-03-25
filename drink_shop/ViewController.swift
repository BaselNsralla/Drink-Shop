//
//  ViewController.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let drinksModel = DrinksModel()
    let drink = DrinkContainer()
    let drinkCell = DrinkListCollectionViewCell()
    let collectionViewContainer = UIView()
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
        view.addSubview(collectionViewContainer)
       
        setupViews()
         setupList ()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setupViews () {
        
        drink.translatesAutoresizingMaskIntoConstraints = false
        drink.heightAnchor.constraint(equalToConstant: CGFloat(350)).isActive = true
        drink.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        drink.backgroundColor = UIColor(red: 204/255, green: 102/255, blue: 153/255, alpha:1)
        drink.layer.shadowColor = UIColor.black.cgColor
        drink.layer.shadowOpacity = 1
        drink.layer.shadowOffset = CGSize.zero
        drink.layer.shadowRadius = 10
        drink.layer.shadowPath = UIBezierPath(rect: drink.bounds).cgPath

        orderButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        orderButton.topAnchor.constraint(equalTo: drink.bottomAnchor, constant: 5).isActive = true
        
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionViewContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionViewContainer.topAnchor.constraint(equalTo: orderButton.bottomAnchor).isActive = true
        collectionViewContainer.heightAnchor.constraint(equalToConstant: 300).isActive = true
        collectionViewContainer.backgroundColor = UIColor.brown
    }
    
    func setupList () {
        
        let drinkList = UICollectionView(frame: collectionViewContainer.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionViewContainer.addSubview(drinkList)
        print("HERE")
        drinkList.showsHorizontalScrollIndicator = true
        drinkList.translatesAutoresizingMaskIntoConstraints = false
        drinkList.dataSource = self
        drinkList.delegate = self
        drinkList.register(DrinkListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        drinkList.backgroundColor = UIColor.red
        view.setNeedsLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinksModel.drinksCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let id = indexPath.row
        let img = drinksModel.drinksListItem[id] == "frappe" ? #imageLiteral(resourceName: "frappe") : #imageLiteral(resourceName: "latte")
        print(drinksModel.drinksListItem[id] )
        let mycell = cell as! DrinkListCollectionViewCell
        mycell.translatesAutoresizingMaskIntoConstraints = false
        mycell.widthAnchor.constraint(equalToConstant: 50).isActive = true
        mycell.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mycell.image = UIImageView(image: img)
        return cell
    }
    
    
}

