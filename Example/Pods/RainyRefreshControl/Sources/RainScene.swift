//
//  RainScene.swift
//  raintest
//
//  Created by Anton Dolzhenko on 14.11.16.
//  Copyright © 2016 Onix Systems. All rights reserved.
//

import UIKit
import SpriteKit

final class RainScene: SKScene {

    var particles:SKEmitterNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setup()
    }
    
    func setup(){
        let bundle = Bundle(for: type(of: self))
        let bundleName = bundle.infoDictionary!["CFBundleName"] as! String
        let path = Bundle(for: type(of: self)).path(forResource: "rain", ofType: "sks", inDirectory: "\(bundleName).bundle")
        if let path = path, let p = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? SKEmitterNode, let texture = UIImage(named: "\(bundleName).bundle/spark", in: bundle, compatibleWith: nil) {
            p.particleTexture = SKTexture(image: texture)
            particles = p
            layout()
            addChild(particles)
        }
    }
    
    func layout(){
        particles.position = CGPoint(x: size.width/2, y: size.height)
    }
}
