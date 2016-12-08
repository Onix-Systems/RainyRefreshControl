//
//  RainyRefreshControl.swift
//  RainyRefreshControl
//
//  Created by Anton Dolzhenko on 14.11.16.
//  Copyright © 2016 Onix Systems. All rights reserved.
//

import UIKit
import SpriteKit

private enum RefreshState {
    case normal
    case pulling
    case loading
}

protocol RainyRefreshControlDelegate {
    func pullToRefreshDidTrigger(_ view: RainyRefreshControl)
}

final class RainyRefreshControl: UIView {

    public var thresholdValue: CGFloat = 100.0
    public var delegate: RainyRefreshControlDelegate?

    private var state: RefreshState = .normal {
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
    private var umbrellaView: UmbrellaView!
    private var scene: RainScene?
    private let defaultBackgroundColor = UIColor(red: 85.0/255.0, green: 74.0/255.0, blue: 99.0/255.0, alpha: 1)

    // MARK: - UIView methods

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleWidth
        backgroundColor = defaultBackgroundColor
        skView = configureSKView()
        addSubview(skView)
        umbrellaView = configureUmbrellaView()
        skView.addSubview(umbrellaView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let scene = configureRainScene()
        skView.presentScene(scene)
        self.scene = scene
        updateUmbrellaView()
    }

    // MARK: - Public ScrollView methods

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

    // MARK: - Private configuration methods

    private func configureSKView() -> SKView {
        let skView = SKView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        skView.backgroundColor = defaultBackgroundColor
        skView.showsFPS = false
        skView.showsNodeCount = false
        // Sprite Kit applies additional optimizations to improve rendering performance
        skView.ignoresSiblingOrder = true
        return skView
    }

    private func configureRainScene() -> RainScene {
        let scene = RainScene(size: skView.bounds.size)
        scene.backgroundColor = defaultBackgroundColor
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        scene.particles.particleBirthRate = 0
        return scene
    }

    private func configureUmbrellaView() -> UmbrellaView {
        let width = skView.frame.height * 0.6
        let umrellaViewFrame = CGRect(x: 0, y: 0, width: width, height: width)
        let umbrellaView = UmbrellaView(frame: umrellaViewFrame)
        umbrellaView.strokeColor = UIColor.white
        umbrellaView.lineWidth = 1
        umbrellaView.backgroundColor = UIColor.clear
        return umbrellaView
    }

    private func updateUmbrellaView() {
        let width = thresholdValue * 0.36
        umbrellaView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        umbrellaView.center = CGPoint(x: center.x, y: skView.frame.height - thresholdValue / 2)
    }

}
