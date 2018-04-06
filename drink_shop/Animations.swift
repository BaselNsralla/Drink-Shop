//
//  Animations.swift
//  drink_shop
//
//  Created by Basel on 2018-04-04.
//  Copyright © 2018 Basel. All rights reserved.
//
import UIKit

struct AnimationsFactory {
     func coreAnimationPosition(animationModel: PositionAnimation) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "position")
        basicAnimation.fromValue = NSValue(cgPoint: animationModel.from)
        basicAnimation.toValue = NSValue(cgPoint: animationModel.to)
        basicAnimation.duration = animationModel.duration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return basicAnimation
    }
    
     func coreAnimationRotation(piRatio: Double, animationDuration : Double) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        basicAnimation.fromValue = 0.0
        basicAnimation.toValue = Double.pi * piRatio
        basicAnimation.duration = animationDuration
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        return basicAnimation
    }
    
     func coreAnimationScale(animationModel: ScaleAnimation)
        -> CABasicAnimation {
            let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
            basicAnimation.fromValue = animationModel.from
            basicAnimation.toValue = animationModel.to
            basicAnimation.duration = animationModel.duration
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.fillMode = animationModel.fillMode
            return basicAnimation
    }
    
     func coreAnimationSpring(_ springPositionModel: PositionAnimation)
        -> CASpringAnimation {
            let springAnimation = CASpringAnimation(keyPath: "position")
            springAnimation.fromValue = springPositionModel.from
            springAnimation.toValue = springPositionModel.to
            springAnimation.duration = springPositionModel.duration
            springAnimation.damping = 6
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
            return springAnimation
    }
    
     func keyFramePositionAnimation (_ animationModel: KeyFramePositionModel) -> CAKeyframeAnimation {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnimation.values = [animationModel.start, animationModel.end, animationModel.swing]
        keyFrameAnimation.keyTimes = [0.25, 0.7, 1]
        keyFrameAnimation.duration = 0.5
        keyFrameAnimation.isRemovedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        return keyFrameAnimation
    }
    
    func customeKeyFrameScaleSpring(_ keyFrameModel: CustomeKeyFrameSpringScaleModel)
        -> CAKeyframeAnimation {
            let jumps = keyFrameModel.jumps
            let timingFunction = keyFrameModel.timingFunction
            let start: Double = keyFrameModel.start ?? 1
            let end = keyFrameModel.end
            let duration = keyFrameModel.duration
            let swing: Double = 1
            var values = [start, end, swing]
            let jumpingVarians: JumpingVarians = keyFrameModel.jumpingVarians ?? .big
            for i in (1...jumps).reversed() {
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
            values.append(swing)
            let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            keyFrameAnimation.values = values
            var bites = [NSNumber]()
            let bite: Double = 1/Double(values.count)
            for i in 0..<values.count {
                bites.append(NSNumber(value: bite*Double(i)))
            }
            keyFrameAnimation.keyTimes = bites
            keyFrameAnimation.duration = duration
            keyFrameAnimation.timingFunction = CAMediaTimingFunction(name: timingFunction)
            return keyFrameAnimation
    }

}


struct CustomeKeyFrameSpringScaleModel {
    let duration: Double
    let start: Double?
    let timingFunction: String
    let jumps: Int
    let end: Double
    let jumpingVarians: JumpingVarians?
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
    let fillMode: String
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






