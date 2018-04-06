//
//  ViewController.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

protocol DrinkViewDelegate {
    func switchDrink()
    func orderDrink()
}

protocol DeleteDelegate {
    func deleteItem(at indexPath: IndexPath, list: UICollectionView)
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CAAnimationDelegate {
    
    let MARGIN: CGFloat = 3
    var drinksModel = DrinksModel()
    let drinkView = DrinkView()
    let modalView = DSModal()
    let animationsFactory = AnimationsFactory()
    var dropPoint: CGPoint!
    var drinkList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let drinkList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return drinkList
    }()
    
    let collectionViewContainer = UIView()
    var textView: UILabel?
    
    let localAttributes: [NSAttributedStringKey : Any]? = [
        .foregroundColor: Colors.pink,
        .strokeWidth: -3.5,
        .font: UIFont.boldSystemFont(ofSize: 75)
    ]

    let fxView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        view.effect = effect
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinkView.delegate = self
        view.backgroundColor = Colors.purple
        view.addSubview(drinkView)
        view.addSubview(collectionViewContainer)
        view.addSubview(fxView)
        setupViews()
        setupList()
        setupText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViews () {
        drinkView.translatesAutoresizingMaskIntoConstraints = false
        drinkView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(1/2) * view.frame.height + 50).isActive = true
        drinkView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        drinkView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        drinkView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drinkView.backgroundColor = Colors.purple
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(drinkSwipe(_:)))
        swipeGesture.direction = .left
        swipeGesture.cancelsTouchesInView = false
        drinkView.addGestureRecognizer(swipeGesture)
        
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionViewContainer.topAnchor.constraint(equalTo: drinkView.bottomAnchor, constant: MARGIN).isActive = true
        collectionViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionViewContainer.backgroundColor = Colors.purple
    }
    
    func setupList () {
        collectionViewContainer.addSubview(drinkList)
        drinkList.register(DrinkCell.self, forCellWithReuseIdentifier: "cell")
        drinkList.showsHorizontalScrollIndicator = false
        drinkList.translatesAutoresizingMaskIntoConstraints = false
        drinkList.dataSource = self
        drinkList.delegate = self
        drinkList.backgroundColor = Colors.purple
        drinkList.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor).isActive = true
        drinkList.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor).isActive = true
        drinkList.rightAnchor.constraint(equalTo: collectionViewContainer.rightAnchor, constant: -view.frame.width/2 + 10).isActive = true
        drinkList.leftAnchor.constraint(equalTo: collectionViewContainer.leftAnchor).isActive = true
        drinkList.isUserInteractionEnabled = true
        drinkList.delaysContentTouches = false
        view.setNeedsLayout()
    }
    
    func setupText() {
        let costText = NSAttributedString(string: drinksModel.cost, attributes: localAttributes)
        textView = UILabel()
        if let textViewObject = textView {
            textViewObject.textAlignment = .center
            textViewObject.adjustsFontSizeToFitWidth = true
            textViewObject.attributedText = costText
            collectionViewContainer.addSubview(textViewObject)
            textViewObject.translatesAutoresizingMaskIntoConstraints = false
            let left = textViewObject.leftAnchor.constraint(equalTo: drinkList.rightAnchor)
            let right = textViewObject.rightAnchor.constraint(equalTo: collectionViewContainer.rightAnchor)
            let center = textViewObject.centerYAnchor.constraint(equalTo: collectionViewContainer.centerYAnchor)
            NSLayoutConstraint.activate([left, right, center])//top, bottom])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drinkView.card.layer.position = CGPoint(x: (drinkView.bounds.minX + view.bounds.width/2) - 30, y: drinkView.bounds.maxY - 50)
        setupKeyFrameAnimations()
        setupAnimations()
        drinksModel.switchDrinks()
    }
}

extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrinkCell
        let id = indexPath.section
        cell.section = id
        cell.deleteDelegate = self
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
        let image = UIImage(named: drinksModel.drinksListItem[id]+"_"+"list")
        cell.image.image = image
        cell.buildConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.section == drinksModel.drinksListItem.count-1 && !drinksModel.animatedLast) {
            drinksModel.animatedLast = true
            let drinkCell = cell as! DrinkCell
            let from =  CGPoint(x: collectionView.bounds.maxX - Constants.cellSize.width/4 , y: -10)
            let to = CGPoint(x: cell.layer.position.x, y: drinkCell.layer.position.y )
            let springAnimation = self.animationsFactory.coreAnimationSpring(PositionAnimation(from: from, to: to, duration: 1.2))
            cell.layer.add(springAnimation, forKey: "springListCell")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        modalView.showModal(at:  CGPoint(x: view.frame.midX, y: collectionView.frame.maxY))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return drinksModel.drinksListItem.count
    }
}

extension ViewController {
    func updatePriceFromModel() {
        if let textViewObject = textView {
            let text = drinksModel.cost
            textViewObject.attributedText = NSMutableAttributedString(string: text, attributes: localAttributes)
        }
    }
}

extension ViewController: DrinkViewDelegate {
    
    func switchDrink() {
        setupKeyFrameAnimations()
        setupAnimations()
        drinksModel.switchDrinks()
    }
    
    func orderDrink() {
        drinksModel.animatedLast = false
        drinksModel.buy(drink: drinksModel.currentDrink)
        drinksModel.drinksListItem.append(drinksModel.currentDrink.rawValue)
        self.drinkList.reloadData()
        animatePrice(){
            let ip = IndexPath(row: 0, section: self.drinksModel.drinksListItem.count-1)
            self.drinkList.scrollToItem(at: ip, at: UICollectionViewScrollPosition.right, animated: true)
        }
        rotateDrink()
    }
    
    @objc
    func drinkSwipe(_: Any?) {
        switchDrink()
    }
}

extension ViewController: DeleteDelegate {
    func deleteItem(at indexPath: IndexPath, list: UICollectionView){
        let section = indexPath.section
        let removed = drinksModel.drinksListItem.remove(at: section)
        let indicies: IndexSet = [section]
        drinksModel.drop(drink: removed)
        list.performBatchUpdates({
            list.deleteItems(at: [indexPath])
            list.deleteSections(indicies)
        }) { (_) in
            list.reloadData()
        }
        animatePrice(){}
    }
}













