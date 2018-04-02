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
    let modalView = DSModal()
    var drinkList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let drinkList = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return drinkList
    }()
    
    let collectionViewContainer = UIView()
    
    let orderButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 204/255, green: 102/255, blue: 153/255,alpha:1)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize.zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowPath = UIBezierPath(rect: btn.bounds).cgPath
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("ORDER", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleShadowColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return btn
    }()
    
    let switchButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 130/255,alpha:1)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize.zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowPath = UIBezierPath(rect: btn.bounds).cgPath
        btn.layer.cornerRadius = 5
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("SWITCH", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleShadowColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        return btn
    }()

    let fxView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        let effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        view.effect = effect
        return view
           //fxView.frame = view.bounds
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(drink)
        view.addSubview(orderButton)
        view.addSubview(collectionViewContainer)
        view.addSubview(switchButton)
        view.addSubview(fxView)
        setupViews()
        setupList (){}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupViews () {
        drink.translatesAutoresizingMaskIntoConstraints = false
        drink.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1.5*view.frame.height/3).isActive = true
        drink.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        drink.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        drink.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drink.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 130/255,alpha:1) //UIColor(red: 204/255, green: 102/255, blue: 153/255, alpha:1)
        drink.layer.shadowColor = UIColor.black.cgColor
        drink.layer.shadowOpacity = 1
        drink.layer.shadowOffset = CGSize.zero
        drink.layer.shadowRadius = 10
        drink.layer.shadowPath = UIBezierPath(rect: drink.bounds).cgPath
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(switchDrink(_:)))
        swipeGesture.direction = .left
        swipeGesture.cancelsTouchesInView = false
        drink.addGestureRecognizer(swipeGesture)
        
        orderButton.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        orderButton.topAnchor.constraint(equalTo: drink.bottomAnchor, constant: MARGIN).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        orderButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: MARGIN).isActive = true
        orderButton.addTarget(self, action: #selector(ViewController.click(_:)), for: .touchDown)
        
        switchButton.topAnchor.constraint(equalTo: drink.bottomAnchor, constant: MARGIN).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        switchButton.leftAnchor.constraint(equalTo: orderButton.rightAnchor, constant: MARGIN).isActive = true
        switchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -MARGIN).isActive = true
        switchButton.addTarget(self, action: #selector(switchDrink(_:)), for: .touchDown)
        
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionViewContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionViewContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionViewContainer.topAnchor.constraint(equalTo: orderButton.bottomAnchor, constant: MARGIN).isActive = true
        collectionViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionViewContainer.backgroundColor = UIColor.brown
    }
    
    func setupList (clojure : () -> Void) {
        collectionViewContainer.addSubview(drinkList)
        drinkList.register(DrinkCell.self, forCellWithReuseIdentifier: "cell")
        drinkList.showsHorizontalScrollIndicator = false
        drinkList.translatesAutoresizingMaskIntoConstraints = false
        drinkList.dataSource = self
        drinkList.delegate = self
        drinkList.backgroundColor = UIColor(red: 75/255, green: 0/255, blue: 130/255,alpha:1)
        drinkList.topAnchor.constraint(equalTo: collectionViewContainer.topAnchor).isActive = true
        drinkList.bottomAnchor.constraint(equalTo: collectionViewContainer.bottomAnchor).isActive = true
        drinkList.rightAnchor.constraint(equalTo: collectionViewContainer.rightAnchor).isActive = true
        drinkList.leftAnchor.constraint(equalTo: collectionViewContainer.leftAnchor).isActive = true
        drinkList.isUserInteractionEnabled = true
        view.setNeedsLayout()
        clojure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drink.card.layer.position = CGPoint(x: (drink.bounds.minX + view.bounds.width/2) - 30, y: drink.bounds.maxY - 50)
        setupKeyFrameAnimations()
        setupAnimations()
        drinksModel.switchDrinks()
    }
    
    private func setupKeyFrameAnimations() {
        let frontView = drink.drinkImages[drinksModel.currentDrinkIndex]
        let backView = drink.drinkImages[drinksModel.backgroundDrinkIndex]
        // This one should fix the center
        let first_x = drink.layer.position.x + 23
        let first_y = drink.layer.position.y
        let end_x = drink.layer.position.x + 125
        let end_y = drink.layer.position.y - 75
        let swing_x = end_x - 25
        let swing_y = end_y
        let reverseKeyFrameModel = KeyFrameModel(start: CGPoint(x: swing_x, y: swing_y), end: CGPoint(x: first_x , y: swing_y + 50), swing: CGPoint(x: first_x, y: first_y))
        let keyFrameModel = KeyFrameModel(start: CGPoint(x: first_x, y: first_y), end: CGPoint(x: end_x, y: end_y), swing: CGPoint(x: swing_x, y: swing_y))
        let frontToBack = makeKeyFramAnimation(keyFrameModel)
        let backToFront = makeKeyFramAnimation(reverseKeyFrameModel)
        backView.layer.add(backToFront, forKey: "backToFront")
        frontView.layer.add(frontToBack, forKey: "frontToBack")
    }
    

    private func setupAnimations() {
        let frontView = drink.drinkImages[drinksModel.currentDrinkIndex]
        let backView = drink.drinkImages[drinksModel.backgroundDrinkIndex]
        let animationGroup = CAAnimationGroup()
        let animationGroupReverse = CAAnimationGroup()
        let endPoint = CGPoint(x: drink.layer.position.x + 25, y: drink.layer.position.y - 25)
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
        let frontView = drink.drinkImages[drinksModel.currentDrinkIndex]
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
    
    private func makeKeyFramAnimation (_ animationModel: KeyFrameModel) -> CAKeyframeAnimation {
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
    
    @objc
    func click(_ sender: AnyObject?) {
        drinksModel.animatedLast = false
        self.drinksModel.drinksListItem.append(self.drinksModel.currentDrink.rawValue)
        rotateDrink(){
            self.drinkList.reloadData()
            let ip = IndexPath(row: 0, section: self.drinksModel.drinksListItem.count-1)
            self.drinkList.scrollToItem(at: ip, at: UICollectionViewScrollPosition.right, animated: true)
        }
    }
    
    @objc
    func switchDrink(_ sender: AnyObject?) {
        print(drinksModel.backgroundDrinkIndex, drinksModel.currentDrinkIndex)
        setupKeyFrameAnimations()
        setupAnimations()
        drinksModel.switchDrinks()
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
        let image = UIImage(named: drinksModel.drinksListItem[id])
        cell.image.image = image
        cell.backgroundColor =  UIColor(red: 75/255, green: 0/255, blue: 130/255,alpha:1)
        //let listener = #selector(drinkTapped(_:))
        //let gesture = UITapGestureRecognizer(target: self, action: listener)
        //cell.addGestureRecognizer(gesture)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150 , height: 150)
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
        if let drinkCell = cell {
            print("the cells layer x value is ", drinkCell.layer.position.x)
            print("the cells frame x value is ", drinkCell.frame.minX)
            print("the cells frame x value is ", drinkCell.bounds.minX)
            modalView.showModal(at: drinkCell.frame)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return drinksModel.drinksListItem.count
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

struct KeyFrameModel {
    let start: CGPoint
    let end: CGPoint
    let swing: CGPoint
}












