//
//  RainyRefreshControl.swift
//  RainyRefreshControl
//
//  Created by Anton Dolzhenko on 14.11.16.
//  Copyright © 2016 Onix Systems. All rights reserved.
//

import UIKit
import SpriteKit

public final class RainyRefreshControl: ONXRefreshControl {
    
    private var backgroundView: SKView!
    var bgColor = UIColor(red: 85.0/255.0, green: 74.0/255.0, blue: 99.0/255.0, alpha: 1)
    private var scene: RainScene?
    private var umbrellaView: UmbrellaView!
    private var thresholdValue: CGFloat = 100.0
    
    override public func setup() {
        delayBeforeEnd = 0.2
        
        backgroundView = SKView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        backgroundView.backgroundColor = bgColor
        addSubview(backgroundView)
        
        backgroundView.showsFPS = false
        backgroundView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        backgroundView.ignoresSiblingOrder = true
        
        scene = RainScene(size: backgroundView.bounds.size)
        // Configure the view.
        scene?.backgroundColor = bgColor
        /* Set the scale mode to scale to fit the window */
        scene?.scaleMode = .aspectFill
        scene?.particles.particleBirthRate = 0
        backgroundView.presentScene(scene)
        
        let width = backgroundView.frame.height*0.6
        umbrellaView = UmbrellaView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        umbrellaView.strokeColor = UIColor.white
        umbrellaView.lineWidth = 1
        umbrellaView.backgroundColor = UIColor.clear
        addSubview(umbrellaView)
    }
    
    override public func layout() {
        backgroundView.frame = bounds
        scene?.size = bounds.size
        scene?.layout()
        
        let width = thresholdValue*0.36
        umbrellaView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        umbrellaView.center = CGPoint(x: center.x, y: backgroundView.frame.height-thresholdValue/2)
    }
    
    override public func didBeginRefresh() {
        scene?.particles.particleBirthRate = 766
        scene?.particles.resetSimulation()
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        CATransaction.commit()
        
        self.umbrellaView.setButtonState(state: .opened, animated: true)
    }
    
    override public func willEndRefresh() {
        scene?.particles.particleBirthRate = 0
        scene?.particles.resetSimulation()
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        CATransaction.commit()
        
        self.umbrellaView.setButtonState(state: .closed, animated: true)
    }
}
