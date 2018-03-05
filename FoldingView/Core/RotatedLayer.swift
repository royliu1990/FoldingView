//
//  RotatedView.swift
//  FoldingView
//
//  Created by royliu1990 on 2018/3/4.
//  Copyright © 2018年 royliu1990. All rights reserved.
//

import UIKit


class RotatedLayer: CALayer {
    private var rotated:CGFloat = 0
}

extension RotatedLayer: CAAnimationDelegate {
    
    func rotatedX(_ angle: CGFloat) {
        var allTransofrom = CATransform3DIdentity
        let rotateTransform = CATransform3DMakeRotation(angle, 1, 0, 0)
        allTransofrom = CATransform3DConcat(allTransofrom, rotateTransform)
        allTransofrom = CATransform3DConcat(allTransofrom, transform3d())
        self.transform = allTransofrom
    }
    
    func transform3d() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5 / -2000
        return transform
    }
    
    // MARK: animations
    
    func foldingAnimation(_ timing: String, from: CGFloat, to: CGFloat, duration: TimeInterval, delay: TimeInterval, hidden: Bool) {
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: timing)
        rotateAnimation.fromValue = from
        rotateAnimation.toValue = to
        rotateAnimation.duration = duration
        rotateAnimation.delegate = self
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.beginTime = CACurrentMediaTime() + delay
        self.rotated = to

        self.add(rotateAnimation, forKey: "rotation.x")
    }
    
    public func animationDidStart(_: CAAnimation) {
        self.shouldRasterize = true

    }
    
    public func animationDidStop(_: CAAnimation, finished _: Bool) {

        self.removeAllAnimations()
        self.shouldRasterize = false
        
        self.rotatedX(self.rotated)
    }
}
