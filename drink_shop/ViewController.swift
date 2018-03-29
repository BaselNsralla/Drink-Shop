//
//  ViewController.swift
//  drink_shop
//
//  Created by Basel on 2018-03-24.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CAAnimationDelegate {
    let MARGIN: CGFloat = 3
    var drinksModel = DrinksModel()
    let drink = DrinkContainer()
    var drinkList: UICollectionView
    let collectionViewContainer = UIView()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 150 , height: 150)
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
        drink.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/1.8).isActive = true
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
    
    private func setupKeyFrameAnimations() {
        let first_x = drink.layer.position.x
        let first_y = drink.layer.position.y
        let end_x = drink.layer.position.x + 75
        let end_y = drink.layer.position.y - 50
        let swing_x = end_x - 50
        let swing_y = end_y + 25
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.values = [CGPoint(x: end_x, y: end_y), CGPoint(x: swing_x, y: swing_y)]
        keyFrameAnimation.keyTimes = [0, 0.5, 1]
        keyFrameAnimation.duration = 1
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        drink.drinkImage.layer.add(keyFrameAnimation, forKey: "CurveSwing")
    }
    
    
    @objc
    func click(_ sender: AnyObject?) {
        drinksModel.drinksListItem.append(drinksModel.currentDrink)
        drinkList.reloadData()
        let ip = IndexPath(row: 0, section: drinksModel.drinksListItem.count-1)
        drinkList.scrollToItem(at: ip, at: UICollectionViewScrollPosition.right, animated: true)
        setupAnimations()
        setupKeyFrameAnimations()
    }
    
    private func setupAnimations() {
        let animatableView = drink.drinkImage
        let animationGroup = CAAnimationGroup()
        let endPoint = CGPoint(x: drink.layer.position.x + 25, y: drink.layer.position.y - 25)
        let scaleAnimationModel = ScaleAnimation(from: 1, to: 0.7, duration: 0.2)
        animationGroup.delegate = self
        animationGroup.animations = [animateDrinkScale(scaleAnimationModel)]
        animationGroup.duration = 0.2
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        animatableView.layer.add(animationGroup, forKey: "transform.scale")
        animatableView.layer.contentsScale = scaleAnimationModel.to
        animatableView.layer.position = endPoint
    }
    
    func animateDrinkPosition() -> CABasicAnimation {
        let startX = drink.layer.position.x
        let startY = drink.layer.position.y
        let endX = drink.layer.position.x + 75
        let endY = drink.layer.position.y - 50
        let startPoint = CGPoint(x: startX, y: startY)
      
        let endPoint = CGPoint(x: endX, y: endY)
        let duration: Double  = 0.2
        let positionAnimation = coreAnimationConstruction(startingPoint: startPoint, endingPoint: endPoint, animationDuration: duration)
       return positionAnimation
    }
    
    func animateDrinkScale(_ animationModel: ScaleAnimation) -> CABasicAnimation {
        let scaleAnimation = coreAnimationScale(startingPoint: animationModel.from, endingPoint: animationModel.to, animationDuration: animationModel.duration)
        return scaleAnimation
    }
    
    func setupList () {
        collectionViewContainer.addSubview(drinkList)
        print("HERE")
        
        drinkList.register(DrinkCell.self, forCellWithReuseIdentifier: "cell")
        drinkList.showsHorizontalScrollIndicator = false
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
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return drinksModel.drinksListItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrinkCell
        let id = indexPath.section
        print("section is ", indexPath.section, "  Item is ", indexPath.item)
        print(id)
        print(drinksModel.drinksListItem[id] )
        let image = UIImage(named: drinksModel.drinksListItem[id])
        cell.image.image = image
        cell.backgroundColor = UIColor.cyan
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150 , height: 150)
    }
}


extension ViewController {
    private func coreAnimationConstruction(startingPoint: CGPoint, endingPoint: CGPoint, animationDuration : Double) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "position")
        basicAnimation.fromValue = NSValue(cgPoint: startingPoint)
        basicAnimation.toValue = NSValue(cgPoint: endingPoint)
        basicAnimation.duration = animationDuration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        return basicAnimation
    }
    
    private func coreAnimationScale(startingPoint: CGFloat, endingPoint: CGFloat, animationDuration: Double)
        -> CABasicAnimation {
            let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
            basicAnimation.fromValue = startingPoint
            basicAnimation.toValue = endingPoint
            basicAnimation.duration = animationDuration
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.fillMode = kCAFillModeForwards
            return basicAnimation
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished scaling")
    }
}

struct ScaleAnimation {
    let from: CGFloat
    let to: CGFloat
    let duration: Double
}











