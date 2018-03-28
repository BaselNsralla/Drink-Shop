//
//  ViewController.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let MARGIN: CGFloat = 3
    var drinksModel = DrinksModel()
    let drink = DrinkContainer()
    var drinkList: UICollectionView
    let collectionViewContainer = UIView()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        drinkList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        drinkList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        super.init(coder: aDecoder)
    }
    
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
        drink.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drink.backgroundColor = UIColor(red: 204/255, green: 102/255, blue: 153/255, alpha:1)
        drink.layer.shadowColor = UIColor.black.cgColor
        drink.layer.shadowOpacity = 1
        drink.layer.shadowOffset = CGSize.zero
        drink.layer.shadowRadius = 10
        drink.layer.shadowPath = UIBezierPath(rect: drink.bounds).cgPath

        orderButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        orderButton.topAnchor.constraint(equalTo: drink.bottomAnchor, constant: MARGIN).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        orderButton.addTarget(self, action: #selector(ViewController.click(_:)), for: .touchDown)
        
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionViewContainer.topAnchor.constraint(equalTo: orderButton.bottomAnchor, constant: MARGIN).isActive = true
        collectionViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionViewContainer.backgroundColor = UIColor.brown
    }
    
    @objc
    func click(_ sender: AnyObject?) {
        
        drinksModel.drinksListItem.append(drinksModel.currentDrink)
        drinkList.reloadData()
        let ip = IndexPath(row: drinksModel.drinksListItem.count-1, section: 0)
        drinkList.scrollToItem(at: ip, at: UICollectionViewScrollPosition.right, animated: true)
    }
    
    func setupList () {
        collectionViewContainer.addSubview(drinkList)
        print("HERE")
        
        drinkList.register(DrinkCell.self, forCellWithReuseIdentifier: "cell")
        drinkList.showsHorizontalScrollIndicator = true
        drinkList.translatesAutoresizingMaskIntoConstraints = false
        drinkList.dataSource = self
        drinkList.delegate = self
        drinkList.backgroundColor = UIColor.red
        drinkList.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor).isActive = true
        drinkList.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor).isActive = true
        drinkList.rightAnchor.constraint(equalTo: collectionViewContainer.rightAnchor).isActive = true
        drinkList.leftAnchor.constraint(equalTo: collectionViewContainer.leftAnchor).isActive = true
        
        view.setNeedsLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinksModel.drinksListItem.count
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrinkCell
        let id = indexPath.row
        print("section is ", indexPath.section, "     Item is ", indexPath.item)
        
        print(id)
        //let img = drinksModel.drinksListItem[id] == "frappe" ? #imageLiteral(resourceName: "frappe") : #imageLiteral(resourceName: "latte")
        print(drinksModel.drinksListItem[id] )
        
        //mycell.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: drinksModel.drinksListItem[id])
        cell.image.image = image
        
        cell.backgroundColor = UIColor.cyan
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    
    
    
}


