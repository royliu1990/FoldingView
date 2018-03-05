//
//  ViewController.swift
//  FoldingView
//
//  Created by royliu1990 on 2018/3/4.
//  Copyright © 2018年 royliu1990. All rights reserved.
//

import UIKit

import SnapKit

class ViewController: UIViewController,CAAnimationDelegate {

    let v = FoldingView()
    let layer = CALayer()
    let layer1 = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        view.addSubview(v)
        
        print(view.layer.anchorPoint)
        
        v.snp.makeConstraints{
            make in
            
            make.center.equalToSuperview()
            
            make.height.equalTo(80)
            
            make.width.equalTo(300)
        }
        
        v.frame = CGRect(x: 50, y: 300, width: 300, height: 80)
        
        let img = UIImageView(image: UIImage(named:"hani"))
        
        v.containerView = img
        
        v.heights = [80,80,40,20]
        
        let fv = UIButton()
        
        fv.setTitle("Tap for Expand!", for: .normal)
        
        fv.setTitleColor(.white, for: .normal)
        
        fv.backgroundColor = .black
        
        fv.alpha = 1.0
        
        v.foregroundView = fv
        
        
        let insideBtn = UIButton()
        
        v.containerView.addSubview(insideBtn)
        
        insideBtn.backgroundColor = .black
        
        insideBtn.setTitle("Tap for Collapse!", for: .normal)
        
        insideBtn.setTitleColor(.white, for: .normal)
        
        insideBtn.alpha = 0.6
        
        insideBtn.snp.makeConstraints{
            make in
            
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
            
        }
        

        fv.addTarget(self, action: #selector(unfolding), for: UIControlEvents.touchUpInside)
        
        insideBtn.addTarget(self, action: #selector(folding), for: UIControlEvents.touchUpInside)

        
        v.construct()

    }
    

    

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    @objc func folding(){
        
        v.fold()

    }
    
    @objc func unfolding(){
        
        v.unfold()
        
    }

}

