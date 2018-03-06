//
//  Foldable.swift
//  FoldingView
//
//  Created by royliu1990 on 2018/3/4.
//  Copyright © 2018年 royliu1990. All rights reserved.
//

import UIKit

open class FoldingView: UIView,CAAnimationDelegate {
    
   public var containerView: UIView! //展开后的view
    
   public var foregroundView: UIView! //闭合时的view

    var animationLayer: CALayer! //展开过程的backview
    
   var backViewColor: UIColor = UIColor.brown //展开过程种的背景图
    
   private var animationItemLayers: [RotatedLayer]! //折叠图
    
   private var animationBackItemLayers: [RotatedLayer]! //背面折叠图

   private var unfolding = false
    
   open var heights:[CGFloat]!
    
   private var animating = false
    
   private func build()
    {
        animationItemLayers = heights.map{_ in
            RotatedLayer()
        }
        
        animationBackItemLayers = heights.map{_ in
            RotatedLayer()
        }
        
        animationBackItemLayers.removeLast()
        
        var height:CGFloat = 0
        
        
        animationLayer = CALayer()
        
        self.layer.addSublayer(animationLayer)
        
        animationLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: heights.reduce(0, +))
        
        animationLayer.backgroundColor = UIColor.clear.cgColor
        
        for (i,v) in heights.enumerated(){

            
            let layer = animationItemLayers[i]
            
            animationLayer.addSublayer(layer)
            
            layer.frame = CGRect(x: 0, y: height - v/2, width: self.bounds.width, height: v)
            
            layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            layer.backgroundColor = UIColor.blue.cgColor
            
            let image = containerView.takeSnapshot(CGRect(x: 0, y: height, width: self.bounds.width, height: v))
            
            layer.contents = image?.cgImage
            layer.contentsScale = 2.0
            if i < heights.count - 1
            {
                let backLayer = animationBackItemLayers[i]
                
                layer.addSublayer(backLayer)
                
                if i == 0
                {
                    
                    backLayer.contents = self.foregroundView.takeSnapshot(CGRect(x: 0, y: 0, width: self.foregroundView.bounds.width, height: self.foregroundView.bounds.height))?.cgImage
    
                    
                }
                
                if i < heights.count - 1
                {

                    backLayer.frame = CGRect(x:0,y:v - heights[i + 1] + heights[i + 1]/2,width:self.foregroundView.bounds.width,height:heights[i + 1])
                    
                }
                
                
                
                backLayer.backgroundColor = UIColor.brown.cgColor
                
                backLayer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
            }
            

            height += v
            
            if i > 0
            {
                layer.rotatedX(CGFloat(-Double.pi/2))
            }

        }
    }
    
    
    private func unfoldTrans(_ finished:@escaping ()->()){
    
        //展开动画
        
        for i in 0..<animationBackItemLayers.count
        {
            let layer = self.animationBackItemLayers[i]
            
            layer.foldingAnimation(kCAMediaTimingFunctionEaseIn, from: 0, to: CGFloat(-Double.pi/2), duration: 0.2, delay: Double(2 * i ) * 0.2, hidden: false)

        }
        
        
        for i in 1..<animationItemLayers.count
        {
            let layer = self.animationItemLayers[i]

            layer.foldingAnimation(kCAMediaTimingFunctionEaseOut, from: CGFloat(Double.pi/2), to: 0, duration: 0.2, delay: (Double(2 * (i - 1)) + 1) * 0.2, hidden: false)
        }
        
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int((Double(2 * animationBackItemLayers.count ) + 1) * 200) - 100)
        
        DispatchQueue.global().asyncAfter(deadline: dispatchTime, execute: {
            self.animating = false
            DispatchQueue.main.async {
                 finished()

            }
           
        })
 
        
    }
    
    private func foldTrans(_ finished:@escaping ()->()){
        
        //关闭动画
        
        
        for i in 0..<animationBackItemLayers.count
        {
            let layer = self.animationBackItemLayers.reversed()[i]
            
            layer.foldingAnimation(kCAMediaTimingFunctionEaseOut, from: CGFloat(-Double.pi/2), to: 0, duration: 0.2, delay: (Double(2 * i ) + 1) * 0.2, hidden: false)
            
        }
        
        
        for i in 0..<animationItemLayers.count - 1
        {
            let layer = self.animationItemLayers.reversed()[i]
            
            layer.foldingAnimation(kCAMediaTimingFunctionEaseIn, from: 0, to: CGFloat(Double.pi/2), duration: 0.2, delay: Double(2 * i ) * 0.2 , hidden: false)
            
        }
        
        let dispatchTime = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int((Double(2 * animationBackItemLayers.count ) + 1) * 200) - 100)
        
        DispatchQueue.global().asyncAfter(deadline: dispatchTime, execute: {
            self.animating = false
            DispatchQueue.main.async {
                finished()

            }
            
        })
        
        
    }
    
   public func unfold(){
        
        if unfolding == true
        {
//            self.fold()
            
            return
        }
        
        if animating{
            return
        }
        
        animating = true
        
        unfolding = true
        
        
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.animationLayer.isHidden = false
        CATransaction.setCompletionBlock{

                self.foregroundView.isHidden = true
                self.containerView.isHidden = true
                self.frame = CGRect(origin: self.frame.origin, size: self.containerView.frame.size)
            
        }
        CATransaction.commit()
        
     
     
  
        unfoldTrans{
            
            self.containerView.isHidden = false
            
            self.animationLayer.isHidden = true

        }
        
  
    }
    
   public func fold(){
        
        
        
        if unfolding == false
        {
//            self.unfold()
            
            return
        }
        
        if animating{
            return
        }
        
        animating = true
        

    
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.animationLayer.isHidden = false
        CATransaction.setCompletionBlock{

                self.containerView.isHidden = true
        }
        
        CATransaction.commit()

        
        unfolding = false
        
        foldTrans {
            
            self.foregroundView.isHidden = false
            
            self.animationLayer.isHidden = true

            self.frame = CGRect(origin: self.frame.origin, size: self.foregroundView.frame.size)
        }
        
        
    }
    
    
   public func construct(){
        
        self.addSubview(containerView)
        
        containerView.isUserInteractionEnabled = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.snp.makeConstraints{
            make in

            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(heights.reduce(0, +))
        }

        self.addSubview(foregroundView)

        

        foregroundView.snp.makeConstraints{
            make in

            make.top.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(heights[0])
        }
        
        
        build()
        containerView.isHidden = true
    }
    
   
}


private extension UIView {
    
    func takeSnapshot(_ frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    
        return image
    }
}


