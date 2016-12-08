//
//  RainyRefreshControl.swift
//  RainyRefreshControl
//
//  Created by Anton Dolzhenko on 14.11.16.
//  Copyright © 2016 Onix Systems. All rights reserved.
//

import UIKit
import SpriteKit

protocol RainyRefreshControlDelegate {
    func pullToRefreshDidTrigger(_ view: RainyRefreshControl) -> ()
}

final class RainyRefreshControl: UIView {

    enum RefreshState {
        case normal
        case pulling
        case loading
    }
    
    public var state: RefreshState = .normal {
        didSet {
            switch state {
            case .pulling:
                scene?.particles.particleBirthRate = 0
            case .loading:
                scene?.particles.particleBirthRate = 766
                scene?.particles.resetSimulation()
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                CATransaction.commit()
            default:
                scene?.particles.particleBirthRate = 0
            }
        }
    }

    private var skView: SKView!
    var umbrellaView: UmbrellaView!
    
    var bgColor = UIColor(red: 85.0/255.0, green: 74.0/255.0, blue: 99.0/255.0, alpha: 1)
    var scene: RainScene?
    
    public var delegate: RainyRefreshControlDelegate?
    public var thresholdValue: CGFloat = 100.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleWidth
        backgroundColor = bgColor
        
        skView = SKView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        skView.backgroundColor = bgColor
        addSubview(skView)
        
        let width = skView.frame.height*0.6
        umbrellaView = UmbrellaView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        umbrellaView.strokeColor = UIColor.white
        umbrellaView.lineWidth = 1
        umbrellaView.backgroundColor = UIColor.clear
        skView.addSubview(umbrellaView)

        state = .normal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skView.showsFPS = false
        skView.showsNodeCount = false
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        scene = RainScene(size: skView.bounds.size)
        // Configure the view.
        scene?.backgroundColor = bgColor
        /* Set the scale mode to scale to fit the window */
        scene?.scaleMode = .aspectFill
        scene?.particles.particleBirthRate = 0
        skView.presentScene(scene)
        let width = thresholdValue*0.36
        umbrellaView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        umbrellaView.center = CGPoint(x: center.x, y: skView.frame.height-thresholdValue/2)
    }
    
    // MARK:ScrollView Methods
    
    public func refreshScrollViewDidScroll(_ scrollView: UIScrollView) {
        if state == .loading {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.2)
            var offset = max(scrollView.contentOffset.y * -1, 0)
            offset = min(offset, thresholdValue)
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0, 0.0, 0.0)
            UIView.commitAnimations()
            
        } else if scrollView.isDragging {
            let loading = false
            if state == .pulling && scrollView.contentOffset.y > -thresholdValue && scrollView.contentOffset.y < 0.0 && !loading {
                state = .normal
                
            } else if state == .normal && scrollView.contentOffset.y < -thresholdValue && !loading {
                state = .pulling
            }
        }

    }
    
    public func refreshScrollViewDidEndDragging(_ scrollView: UIScrollView) {
        let loading = false
        if scrollView.contentOffset.y <= -thresholdValue && !loading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.umbrellaView.setButtonState(state: .opened, animated: true)
            }
            state = .loading
            delegate?.pullToRefreshDidTrigger(self)
        }
    }
    
    public func refreshScrollViewDataSourceDidFinishedLoading(_ scrollView: UIScrollView) {
        umbrellaView.setButtonState(state: .closed, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.4)
            scrollView.contentInset = UIEdgeInsets.zero
            UIView.commitAnimations()
            self.state = .normal
        }
        
    }


}
