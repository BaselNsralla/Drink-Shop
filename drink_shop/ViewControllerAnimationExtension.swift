//
//  ViewControllerAnimationExtension.swift
//  drink_shop
//
//  Created by Basel on 2018-04-05.
//  Copyright © 2018 Basel. All rights reserved.
//

import UIKit
extension ViewController {
    func setupKeyFrameAnimations() {
        let frontView = drinkView.drinkImages[drinksModel.currentDrinkIndex]
        let backView = drinkView.drinkImages[drinksModel.backgroundDrinkIndex]
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
    
    
    func setupAnimations() {
        let frontView = drinkView.drinkImages[drinksModel.currentDrinkIndex]
        let backView = drinkView.drinkImages[drinksModel.backgroundDrinkIndex]
        let animationGroup = CAAnimationGroup()
        let animationGroupReverse = CAAnimationGroup()
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
        if let textViewObject = textView {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {self.updatePriceFromModel(); cellAnimation();})
            let animation = animationsFactory.customeKeyFrameScaleSpring(CustomeKeyFrameSpringScaleModel(duration: 2, start: nil, timingFunction: kCAMediaTimingFunctionDefault, jumps: 2, end: 0.05, jumpingVarians: .big))
            textViewObject.layer.add(animation, forKey: "flexingText")
            textViewObject.layer.rasterizationScale = 1
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Finished scaling")
    }
}
