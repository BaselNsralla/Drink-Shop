//
//  Animations.swift
//  drink_shop
//
//  Created by Basel on 2018-04-04.
//  Copyright © 2018 Basel. All rights reserved.
//

import Foundation
import UIKit
class AnimationsFactory {
}

extension AnimationsFactory {
     func coreAnimationPosition(animationModel: PositionAnimation) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "position")
        basicAnimation.fromValue = NSValue(cgPoint: animationModel.from)
        basicAnimation.toValue = NSValue(cgPoint: animationModel.to)
        basicAnimation.duration = animationModel.duration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return basicAnimation
    }
    
     func coreAnimationRotation(startingPoint: CGPoint, endingPoint: CGPoint, animationDuration : Double) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        basicAnimation.fromValue = NSValue(cgPoint: startingPoint)
        basicAnimation.toValue = NSValue(cgPoint: endingPoint)
        basicAnimation.duration = animationDuration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        return basicAnimation
    }
    
     func coreAnimationScale(startingPoint: CGFloat, endingPoint: CGFloat, animationDuration: Double)
        -> CABasicAnimation {
            let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
            basicAnimation.fromValue = startingPoint
            basicAnimation.toValue = endingPoint
            basicAnimation.duration = animationDuration
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.fillMode = kCAFillModeForwards
            return basicAnimation
    }
    
     func coreAnimationSpring(_ springPositionModel: PositionAnimation)
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
    
     func coreAnimationScaleSpring(_ springPositionModel: ScaleAnimation)
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
    
     func coreAnimationKeyFrameScaleSpring(_ keyFrameModel: KeyFrameScaleSpringModel)
        -> CAKeyframeAnimation {
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            keyFrameAnimation.values = [keyFrameModel.start, keyFrameModel.end, keyFrameModel.swing, keyFrameModel.swing+0.1,keyFrameModel.swing - 0.1, keyFrameModel.swing+0.05, keyFrameModel.start]
            //            var times: [NSNumber] = [0, 0.3, 0.55, 0.75, 0.85, 0.95, 1].map{return NSNumber(value: (Double($0)/0.1)*1)}
            //            keyFrameAnimation.keyTimes = [0, 0.3, 0.55, 0.75, 0.85, 0.95, 1]
            //            keyFrameAnimation.duration = 1.1
            var bites = [NSNumber]()
            let bite: Double = 1/7
            for i in 0..<7 {
                bites.append(NSNumber(value: bite*Double(i)))
            }
            bites.removeLast()
            bites.append(NSNumber(value: 1))
            print(bites)
            keyFrameAnimation.keyTimes = bites
            keyFrameAnimation.duration = 1.5
            keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            return keyFrameAnimation
    }
    
     func customeKeyFrameSpringScale(_ keyFrameModel: CustomeKeyFrameSpringScaleModel)
        -> CAKeyframeAnimation {
            let jumps = 5
            let timingFunction = kCAMediaTimingFunctionEaseInEaseOut
            let start: Double = 1
            let end = 0.4
            let duration = 1.5
            let swing: Double = 1
            var values = [start, end, swing]
            let jumpingVarians: Constants.JumpingVarians = .small
            for i in jumps...1 {
                let factor = Double(i)
                switch jumpingVarians {
                case .small:
                    values.append(swing + 0.05 * factor)
                    values.append(swing - 0.05 * factor)
                case .big:
                    values.append(swing + 0.1 * factor)
                    values.append(swing - 0.1 * factor)
                case .bigThenSmall:
                    values.append(swing + (0.1/(i < jumps/2 ? 2 : 1) * factor))
                    values.append(swing - (0.1/(i < jumps/2 ? 2 : 1) * factor))
                case .smallThenBig:
                    values.append(swing + (0.1/(i < jumps/2 ? 1 : 2) * factor))
                    values.append(swing - (0.1/(i < jumps/2 ? 1 : 2) * factor))
                }
            }
            values.append(end)
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            keyFrameAnimation.values = values
            var bites = [NSNumber]()
            let bite: Double = 1/Double(values.count)
            for i in 0..<values.count {
                bites.append(NSNumber(value: bite*Double(i)))
            }
            bites.removeLast()
            bites.append(NSNumber(value: 1))
            print(bites)
            keyFrameAnimation.keyTimes = bites
            keyFrameAnimation.duration = duration
            keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction)
            return keyFrameAnimation
    }
    
    
     func makeKeyFramAnimation (_ animationModel: KeyFramePositionModel) -> CAKeyframeAnimation {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.values = [animationModel.start, animationModel.end, animationModel.swing]
        keyFrameAnimation.keyTimes = [0.25, 0.7, 1]
        keyFrameAnimation.duration = 0.5
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return keyFrameAnimation
    }
}


struct CustomeKeyFrameSpringScaleModel {
    
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






