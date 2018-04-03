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
        drinkView.delegate = self
        view.backgroundColor = Colors.blue
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
        drinkView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1.5*view.frame.height/3).isActive = true
        drinkView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        drinkView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        drinkView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drinkView.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 130/255,alpha:1)
        drinkView.layer.shadowColor = UIColor.black.cgColor
        drinkView.layer.shadowOpacity = 1
        drinkView.layer.shadowOffset = CGSize.zero
        drinkView.layer.shadowRadius = 10
        drinkView.layer.shadowPath = UIBezierPath(rect: drinkView.bounds).cgPath
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(drinkSwipe(_:)))
        swipeGesture.direction = .left
        swipeGesture.cancelsTouchesInView = false
        drinkView.addGestureRecognizer(swipeGesture)
        
//        orderButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
//        orderButton.topAnchor.constraint(equalTo: drinkView.bottomAnchor, constant: MARGIN).isActive = true
//        orderButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
//        orderButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: MARGIN).isActive = true
//        //orderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        orderButton.addTarget(self, action: #selector(ViewController.click(_:)), for: .touchDown)
//
//        switchButton.topAnchor.constraint(equalTo: drinkView.bottomAnchor, constant: MARGIN).isActive = true
//        switchButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
//        switchButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
//        //switchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        switchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -MARGIN).isActive = true
//        switchButton.addTarget(self, action: #selector(switchDrink(_:)), for: .touchDown)
        
        
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
//        drinkList.layer.shadowColor = UIColor.blackColor().CGColor
//        drinkList.layer.shadowOffset = CGSizeMake(0, 1)
//        drinkList.layer.shadowOpacity = 1
//        drinkList.layer.shadowRadius = 1.0
//        drinkList.clipsToBounds = false
//        drinkList.layer.masksToBounds = false
        view.setNeedsLayout()
        clojure()
    }
    
    func setupText() {
        //var font = UIFont.preferredFont(forTextStyle: .headline)
        let costText = NSAttributedString(string: drinksModel.cost, attributes: localAttributes)
        textView = UILabel()
        //textView?.backgroundColor = Colors.blue
        textView?.textAlignment = .center
        textView?.adjustsFontSizeToFitWidth = true
        textView?.contentMode = UIViewContentMode.center
        if let textViewObject = textView {
            textViewObject.attributedText = costText
            collectionViewContainer.addSubview(textViewObject)
            textViewObject.translatesAutoresizingMaskIntoConstraints = false
            let left = textViewObject.leftAnchor.constraint(equalTo: drinkList.rightAnchor)
            let right = textViewObject.rightAnchor.constraint(equalTo: collectionViewContainer.rightAnchor)
            //let top = textViewObject.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor)
            //let bottom = textViewObject.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor)
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
        let first_x = drinkView.layer.position.x + 23
        let first_y = drinkView.layer.position.y
        let end_x = drinkView.layer.position.x + 125
        let end_y = drinkView.layer.position.y - 75
        let swing_x = end_x - 25
        let swing_y = end_y
        let reverseKeyFrameModel = KeyFramePositionModel(start: CGPoint(x: swing_x, y: swing_y), end: CGPoint(x: first_x , y: swing_y + 50), swing: CGPoint(x: first_x, y: first_y))
        let keyFrameModel = KeyFramePositionModel(start: CGPoint(x: first_x, y: first_y), end: CGPoint(x: end_x, y: end_y), swing: CGPoint(x: swing_x, y: swing_y))
        let frontToBack = makeKeyFramAnimation(keyFrameModel)
        let backToFront = makeKeyFramAnimation(reverseKeyFrameModel)
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
        
        let scaleAnimationModel = ScaleAnimation(from: 1, to: 0.4, duration: 0.2)
        animationGroup.delegate = self
        animationGroup.animations = [animateDrinkScale(scaleAnimationModel)]
        animationGroup.duration = 0.2
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false
        
        let scaleAnimationModelReverse = ScaleAnimation(from: 0.4, to: 1, duration: 0.2)
        animationGroupReverse.delegate = self
        animationGroupReverse.animations = [animateDrinkScale(scaleAnimationModelReverse)]
        animationGroupReverse.duration = 0.2
        animationGroupReverse.fillMode = kCAFillModeForwards
        animationGroupReverse.isRemovedOnCompletion = false
        
        frontView.layer.zPosition = 2
        backView.layer.zPosition = 3
        
        frontView.layer.add(animationGroup, forKey: "transform.scale")
        backView.layer.add(animationGroupReverse, forKey: "transform.scale")
    
        frontView.layer.contentsScale = scaleAnimationModel.to
        backView.layer.contentsScale = scaleAnimationModelReverse.to
        frontView.layer.position = endPoint
        backView.layer.position = endPoint

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
    
    func rotateDrink (cellAnimation: @escaping () -> Void) {
        let frontView = drinkView.drinkImages[drinksModel.currentDrinkIndex]
        let aDuration = 0.4
        // Group these
        UIView.animateKeyframes(withDuration: aDuration, delay: 0, options: [.calculationModeCubicPaced],
            animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                frontView.transform = CGAffineTransform(translationX: -10, y:  -50)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
               frontView.transform = CGAffineTransform(rotationAngle: CGFloat(-Float.pi/2/3))
            })
               
        }, completion: { (_: Bool) in
            cellAnimation()
            UIView.animate(withDuration: 0.2, animations: {
                frontView.transform = CGAffineTransform(rotationAngle: CGFloat(0))
            })
        })
    }
    
    func animateDrinkScale(_ animationModel: ScaleAnimation) -> CABasicAnimation {
        let scaleAnimation = coreAnimationScale(startingPoint: animationModel.from, endingPoint: animationModel.to, animationDuration: animationModel.duration)
        return scaleAnimation
    }
    
    func animatePrice() {
        //let animationModel = ScaleAnimation(from: 1, to: 1.4, duration: 0.65)
        //let animation = coreAnimationScaleSpring(animationModel)
        let animationModel = KeyFrameScaleSpringModel(start: 1, end: 1.4, swing: 1)
        let animation = coreAnimationKeyFrameScaleSpring(animationModel)
        if let textViewObject = textView {
            CATransaction.begin()
            textViewObject.layer.add(animation, forKey: "scaleText")
            textViewObject.layer.contentsScale = animationModel.end
            CATransaction.commit()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.142, execute: {self.updatePriceFromModel()})
            print("LABEL IS ANIMATING")
            
//            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
//                textViewObject.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            }, completion: { (_) in
//                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
//                    textViewObject.transform = CGAffineTransform(scaleX: 1, y: 1)
//                }, completion: { (_) in
//
//                })
//            })
            
        }
    }
}


extension ViewController {
    private func coreAnimationPosition(animationModel: PositionAnimation) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "position")
        basicAnimation.fromValue = NSValue(cgPoint: animationModel.from)
        basicAnimation.toValue = NSValue(cgPoint: animationModel.to)
        basicAnimation.duration = animationModel.duration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return basicAnimation
    }
    
    private func coreAnimationRotation(startingPoint: CGPoint, endingPoint: CGPoint, animationDuration : Double) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
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
    
    private func coreAnimationSpring(_ springPositionModel: PositionAnimation)
        -> CASpringAnimation {
            let springAnimation = CASpringAnimation(keyPath: "position")
            springAnimation.fromValue = springPositionModel.from
            springAnimation.toValue = springPositionModel.to
            springAnimation.duration = springPositionModel.duration
            springAnimation.damping = 8
            springAnimation.isRemovedOnCompletion = true
            //springAnimation.fillMode = kCAFillModeForwards
            return springAnimation
    }
    
    private func coreAnimationScaleSpring(_ springPositionModel: ScaleAnimation)
        -> CASpringAnimation {
            let springAnimation = CASpringAnimation(keyPath: "transform.scale")
            springAnimation.fromValue = springPositionModel.from
            springAnimation.toValue = springPositionModel.to
            springAnimation.duration = springPositionModel.duration
            springAnimation.damping = 0.1
            springAnimation.initialVelocity = 1
            //springAnimation.isRemovedOnCompletion = true
            //springAnimation.fillMode = kCAFillModeForwards
            return springAnimation
    }
    
    private func coreAnimationKeyFrameScaleSpring(_ keyFrameModel: KeyFrameScaleSpringModel)
        -> CAKeyframeAnimation {
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            keyFrameAnimation.values = [keyFrameModel.start, keyFrameModel.end, keyFrameModel.swing, keyFrameModel.swing+0.2,keyFrameModel.swing - 0.1, keyFrameModel.swing+0.1, keyFrameModel.start]
//            var times: [NSNumber] = [0, 0.3, 0.55, 0.75, 0.85, 0.95, 1].map{return NSNumber(value: (Double($0)/0.1)*1)}
//            keyFrameAnimation.keyTimes = [0, 0.3, 0.55, 0.75, 0.85, 0.95, 1]
//            keyFrameAnimation.duration = 1.1
            var bites = [NSNumber]()
            let bite: Double = 1/7
            for i in 0..<7 {
                bites.append(NSNumber(value: bite*Double(i)))
            }
            print(bites)
            keyFrameAnimation.keyTimes = bites
            keyFrameAnimation.duration = 1.2
            keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            return keyFrameAnimation
    }
    
    
    private func makeKeyFramAnimation (_ animationModel: KeyFramePositionModel) -> CAKeyframeAnimation {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.values = [animationModel.start, animationModel.end, animationModel.swing]
        keyFrameAnimation.keyTimes = [0.25, 0.7, 1]
        keyFrameAnimation.duration = 0.5
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return keyFrameAnimation
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished scaling")
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
        print("section is ", indexPath.section, "  Item is ", indexPath.item)
        print(id)
        print("Row", indexPath.row)
        print(drinksModel.drinksListItem[id] )
        let image = UIImage(named: drinksModel.drinksListItem[id]+"_"+"list")
        cell.image.image = image
        cell.backgroundColor =  Colors.purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110 , height: 175)
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
            let from = CGPoint(x: cell.layer.position.x, y: -10)
            let to = CGPoint(x: cell.layer.position.x, y: drinkCell.layer.position.y )
            let springAnimation = self.coreAnimationSpring(PositionAnimation(from: from, to: to, duration: 1.2))
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
            //textViewObject.text = textViewObject.attributedText!.string
            //textViewObject.adjustsFontSizeToFitWidth = true
//            textViewObject.text = drinksModel.cost
//            textViewObject.font = UIFont.boldSystemFont(ofSize: 30)
//            textViewObject.textColor = Colors.pink
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
        animatePrice()
        rotateDrink(){
            self.drinkList.reloadData()
            let ip = IndexPath(row: 0, section: self.drinksModel.drinksListItem.count-1)
            self.drinkList.scrollToItem(at: ip, at: UICollectionViewScrollPosition.right, animated: true)
        }
    }
    
    @objc
    func drinkSwipe(_: Any?) {
        switchDrink()
    }
}

struct PositionAnimation {
    let from: CGPoint
    let to: CGPoint
    let duration: Double
}

struct ScaleAnimation {
    let from: CGFloat
    let to: CGFloat
    let duration: Double
}

struct KeyFramePositionModel {
    let start: CGPoint
    let end: CGPoint
    let swing: CGPoint
}

struct KeyFrameScaleSpringModel {
    let start: CGFloat
    let end: CGFloat
    let swing: CGFloat
}











