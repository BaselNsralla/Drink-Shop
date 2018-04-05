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
           //fxView.frame = view.bounds
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        drinkView.delegate = self
        view.backgroundColor = Colors.purple
        view.addSubview(drinkView)
        //view.addSubview(orderButton)
        view.addSubview(collectionViewContainer)
        //view.addSubview(switchButton)
        view.addSubview(fxView)
        setupViews()
        setupList(){}
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
        drinkView.layer.shadowColor = UIColor.black.cgColor
        drinkView.layer.shadowOpacity = 1
        drinkView.layer.shadowOffset = CGSize.zero
        drinkView.layer.shadowRadius = 10
        drinkView.layer.shadowPath = UIBezierPath(rect: drinkView.bounds).cgPath
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
    
    func setupList (clojure : () -> Void) {
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
        clojure()
    }
    
    func setupText() {
        let costText = NSAttributedString(string: drinksModel.cost, attributes: localAttributes)
        textView = UILabel()
        textView?.textAlignment = .center
        textView?.adjustsFontSizeToFitWidth = true
        if let textViewObject = textView {
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
    
    private func setupKeyFrameAnimations() {
        let frontView = drinkView.drinkImages[drinksModel.currentDrinkIndex]
        let backView = drinkView.drinkImages[drinksModel.backgroundDrinkIndex]
        // This one should fix the center
        let first_x = frontView.layer.position.x
        let first_y = frontView.layer.position.y
        let end_x = frontView.layer.position.x + 125
        let end_y = frontView.layer.position.y - 75
        let swing_x = end_x - 25
        let swing_y = end_y
        let reverseKeyFrameModel = KeyFramePositionModel(start: CGPoint(x: swing_x, y: swing_y), end: CGPoint(x: first_x , y: swing_y + 50), swing: CGPoint(x: first_x, y: first_y))
        let keyFrameModel = KeyFramePositionModel(start: CGPoint(x: first_x, y: first_y), end: CGPoint(x: end_x, y: end_y), swing: CGPoint(x: swing_x, y: swing_y))
        let frontToBack = animationsFactory.keyFramePositionAnimation(keyFrameModel)
        let backToFront = animationsFactory.keyFramePositionAnimation(reverseKeyFrameModel)
        backView.layer.add(backToFront, forKey: "backToFront")
        frontView.layer.add(frontToBack, forKey: "frontToBack")
    }
    

    private func setupAnimations() {
        let frontView = drinkView.drinkImages[drinksModel.currentDrinkIndex]
        let backView = drinkView.drinkImages[drinksModel.backgroundDrinkIndex]
        let animationGroup = CAAnimationGroup()
        let animationGroupReverse = CAAnimationGroup()
        let endPoint = CGPoint(x: drinkView.layer.position.x + 25, y: drinkView.layer.position.y - 25)
        let rotationDuration: Double = 0.2
        
        let scaleAnimationModel = ScaleAnimation(from: 1, to: 0.4, duration: 0.2, fillMode: kCAFillModeForwards)
        animationGroup.delegate = self
        animationGroup.animations = [ animationsFactory.coreAnimationScale(animationModel: scaleAnimationModel)]
        animationGroup.duration = 0.2
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        
        let scaleAnimationModelReverse = ScaleAnimation(from: 0.4, to: 1, duration: 0.2, fillMode: kCAFillModeForwards)
        animationGroupReverse.delegate = self
        animationGroupReverse.animations = [ animationsFactory.coreAnimationScale(animationModel: scaleAnimationModelReverse)]
        animationGroupReverse.duration = 0.2
        animationGroupReverse.fillMode = kCAFillModeForwards
        animationGroupReverse.isRemovedOnCompletion = false
        
        frontView.layer.zPosition = 2
        backView.layer.zPosition = 3
        
        frontView.layer.add(animationGroup, forKey: "transform.scale")
        backView.layer.add(animationGroupReverse, forKey: "transform.scale")
    
        frontView.layer.contentsScale = scaleAnimationModel.to
        backView.layer.contentsScale = scaleAnimationModelReverse.to
        frontView.layer.position = frontView.layer.position
        backView.layer.position = frontView.layer.position

        UIView.animate(withDuration: rotationDuration,delay:0 ,options: UIViewAnimationOptions.curveEaseIn, animations: {
            backView.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi/2/4))
            frontView.transform = CGAffineTransform(rotationAngle: CGFloat(-Float.pi/2/4))
        }){ (_) in
            UIView.animate(withDuration: rotationDuration, animations: {
                backView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                frontView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            })
        }
    }
    
    func rotateDrink () {
        let frontView = drinkView.drinkImages[drinksModel.currentDrinkIndex]

        let first_x = frontView.layer.position.x
        let first_y = frontView.layer.position.y
         let endPoint = CGPoint(x: frontView.layer.position.x, y: frontView.layer.position.y)
        
        let aDuration = 0.23
        let fullRotation: Double = -0.25/1.4
        let positionAnimationModel = PositionAnimation(from: CGPoint(x: first_x, y: first_y) , to: CGPoint(x: frontView.layer.position.x - 50, y: frontView.layer.position.y - 60), duration: aDuration)
        let scaleAnimationModel = ScaleAnimation(from: 1, to: 0.8, duration: aDuration, fillMode: kCAFillModeForwards)
       CATransaction.begin()
         CATransaction.setCompletionBlock {}
         let animationGroup = CAAnimationGroup()
         animationGroup.animations = [animationsFactory.coreAnimationPosition(animationModel: positionAnimationModel), animationsFactory.coreAnimationRotation(piRatio: fullRotation, animationDuration: aDuration),
            animationsFactory.coreAnimationScale(animationModel: scaleAnimationModel)]
         animationGroup.duration = aDuration
         animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
         animationGroup.autoreverses = true
         animationGroup.fillMode = kCAFillModeForwards
         animationGroup.isRemovedOnCompletion = true
         frontView.layer.add(animationGroup, forKey: "pickAnimation")
         frontView.layer.position = endPoint
       CATransaction.commit()
    }
 
    
    func animatePrice(cellAnimation: @escaping () -> Void) {
        let animationModel = KeyFrameScaleSpringModel(start: 1, end: 0.05, swing: 1)
        let animation = animationsFactory.keyFrameScaleSpringAnimation(animationModel)
        if let textViewObject = textView {
//            CATransaction.begin()
//            CATransaction.setCompletionBlock({
//                self.textView?.contentScaleFactor = 1
//            })
//            textViewObject.layer.add(animation, forKey: "scaleText")
//            textViewObject.contentScaleFactor = animationModel.start
//            CATransaction.commit()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {self.updatePriceFromModel(); cellAnimation()})
//
//
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                textViewObject.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            }, completion: { (_) in
                self.updatePriceFromModel(); cellAnimation()
                UIView.animate(withDuration: 1.1, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 7, options: .curveEaseOut, animations: {
                       textViewObject.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            })
            
            
        }
    }
}

extension ViewController {
    
    @objc func drinkTapped(_ sender: UICollectionViewCell) {
        //fxView.frame = view.bounds
        //modalView.showModal(at: sender.frame)
    }
    

}

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrinkCell
        let id = indexPath.section
        cell.section = id
        print("section is ", indexPath.section, "  Item is ", indexPath.item)
        print(id)
        print("Row", indexPath.row)
        print(drinksModel.drinksListItem[id] )
        let image = UIImage(named: drinksModel.drinksListItem[id]+"_"+"list")
        cell.image.image = image
        cell.backgroundColor = UIColor(white: 1, alpha: 0)
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
            if collectionView.numberOfSections > 2 {
                let previousCell = collectionView.cellForItem(at: IndexPath(row: 0, section:indexPath.section - 1 ))
            }
            let from =  CGPoint(x: collectionView.bounds.maxX - Constants.cellSize.width/4 , y: -10)
            let to = CGPoint(x: cell.layer.position.x, y: drinkCell.layer.position.y )
            let springAnimation = self.animationsFactory.coreAnimationSpring(PositionAnimation(from: from, to: to, duration: 1.2))
            cell.layer.add(springAnimation, forKey: "springListCell")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SELECTED ITEM")
        let cell = collectionView.cellForItem(at: indexPath)
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
        print(drinksModel.backgroundDrinkIndex, drinksModel.currentDrinkIndex)
        setupKeyFrameAnimations()
        setupAnimations()
        drinksModel.switchDrinks()
    }
    
    func orderDrink() {
        drinksModel.animatedLast = false
        drinksModel.drinksListItem.append(drinksModel.currentDrink.rawValue)
        drinksModel.buy(drink: drinksModel.currentDrink)
        animatePrice(){
            self.drinkList.reloadData()
            let ip = IndexPath(row: 0, section: self.drinksModel.drinksListItem.count-1)
            self.drinkList.scrollToItem(at: ip, at: UICollectionViewScrollPosition.right, animated: true)
        }
        rotateDrink()
    }
    
    @objc
    func drinkSwipe(_: Any?) {
        switchDrink()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished scaling")
    }
}












