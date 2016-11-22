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
        if let p = SKEmitterNode(fileNamed: "rain.sks") {
            particles = p
            particles.position = CGPoint(x: size.width, y: size.height/2)
            addChild(particles)
        }
    }
}
