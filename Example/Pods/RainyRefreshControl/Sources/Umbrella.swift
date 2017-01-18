//
//  Umbrella.swift
//  RainyRefresh
//
//  Created by Anton Dolzhenko on 16.11.16.
//  Copyright © 2016 Onix Systems. All rights reserved.
//

import UIKit

enum UmbrellaState {
    case closed
    case opened
    var value: CGFloat {
        return (self == .opened) ? 0.0 : 1.0
    }
}

final class UmbrellaView:UIView {
    
    var lineWidth:CGFloat = 1.0
    var strokeColor: UIColor = .white

    private(set) var state = UmbrellaState.closed
    private var animationValue: CGFloat {
        set {
            if let layer = layer as? UmbrellaLayer {
                layer.animationValue = newValue
            }
        }
        get {
            if let layer = layer as? UmbrellaLayer {
                return layer.animationValue
            }
            return 0.0
        }
    }
    
    override class var layerClass : AnyClass {
        return UmbrellaLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let layer = layer as? UmbrellaLayer {
            layer.contentsScale = UIScreen.main.scale
            layer.lineWidth = lineWidth
            layer.strokeColor = strokeColor
        }
        animationValue = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    func setButtonState(state: UmbrellaState, animated: Bool) {
        if self.state == state {
            return
        }
        self.state = state
        
        let toValue: CGFloat = state.value
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.animationValue = toValue
            })
        } else {
            animationValue = toValue
        }
    }
}

final class UmbrellaLayer:CALayer {
    @NSManaged var animationValue: CGFloat
    var lineWidth:CGFloat = 1.0
    var strokeColor:UIColor = .white
    
    private var APoint:CGPoint!
    private var aPoint:CGPoint!
    private var a1Point:CGPoint!
    
    private var BPoint:CGPoint!
    private var bPoint:CGPoint!
    private var b1Point:CGPoint!
    
    private var CPoint:CGPoint!
    private var cPoint:CGPoint!
    
    private var DPoint:CGPoint!
    private var dPoint:CGPoint!
    private var d1Point:CGPoint!
    
    private var EPoint:CGPoint!
    private var ePoint:CGPoint!
    private var e1Point:CGPoint!
    
    private var FPoint:CGPoint!
    
    fileprivate class func isCustomAnimKey(_ key: String) -> Bool {
        return key == "animationValue"
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if self.isCustomAnimKey(key) {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        if UmbrellaLayer.isCustomAnimKey(event) {
            if let animation = super.action(forKey: "backgroundColor") as? CABasicAnimation {
                animation.keyPath = event
                if let pLayer = presentation() {
                    animation.fromValue = pLayer.animationValue
                }
                animation.toValue = nil
                return animation
            }
            setNeedsDisplay()
            return nil
        }
        return super.action(forKey: event)
    }
    
    func update() {
        let midX = bounds.midX
        let midY = bounds.midY
        let width = bounds.width
        let height = bounds.height
        
        APoint = CGPoint(x: (midX-width*0.4133)+(width*0.3633*animationValue), y: (midY+0.055*height)+(height*0.0683*animationValue))
        aPoint = CGPoint(x: (midX-width*0.385)+(width*0.3366*animationValue), y: (midY-height*0.3716)-(height*0.0016*animationValue))
        a1Point = CGPoint(x: (midX-width*0.3033)+(width*0.265*animationValue), y: (midY-height*0.1166)+(height*0.07*animationValue))
        
        BPoint = CGPoint(x: (midX-width*0.2033)+(width*0.1783*animationValue), y: (midY+height*0.0433)+(height*0.0783*animationValue))
        bPoint = CGPoint(x: (midX-width*0.2233)+(width*0.1957*animationValue), y: (midY-height*0.295)+(height*0.0129*animationValue))
        b1Point = CGPoint(x: (midX-width*0.0892)+(width*0.0792*animationValue), y: (midY-height*0.105)+(height*0.105*animationValue))
        
        CPoint = CGPoint(x: midX, y: (midY+height*0.0433)+(height*0.0783*animationValue))
        
        DPoint = CGPoint(x: (midX+width*0.2033)-(width*0.1783*animationValue), y: (midY+height*0.0433)+(height*0.0783*animationValue))
        dPoint = CGPoint(x: (midX+width*0.2175)-(width*0.1908*animationValue), y: (midY-height*0.295)+(height*0.0129*animationValue))
        d1Point = CGPoint(x: (midX+width*0.0894)-(width*0.0778*animationValue), y:(midY-height*0.105)+(height*0.105*animationValue))
        
        EPoint = CGPoint(x: (midX+width*0.4133)-(width*0.3633*animationValue), y: (midY+height*0.0566)+(height*0.0666*animationValue))
        ePoint = CGPoint(x: (midX+width*0.385)-(width*0.3366*animationValue), y: (midY-height*0.375)+(height*0.0016*animationValue))
        e1Point = CGPoint(x: (midX+width*0.3116)-(width*0.2733*animationValue), y: (midY-height*0.1091)+(height*0.0625*animationValue))
        
        FPoint = CGPoint(x: midX, y: (midY-height*0.3683)-(0.0016*animationValue))
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        ctx.setStrokeColor(strokeColor.cgColor)
        ctx.setLineWidth(lineWidth)
        
        update()
        //// Draw a handle
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bounds.midX, y: bounds.midY+bounds.height*0.4266))
        bezierPath.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY-bounds.height*0.415))
        
        let arrayOfDots:[(CGPoint,CGPoint,CGPoint,CGPoint)] = [(APoint,FPoint,aPoint,FPoint),
                                                               (FPoint,EPoint,FPoint,ePoint),
                                                               (BPoint,FPoint,bPoint,FPoint),
                                                               (APoint,BPoint,a1Point,BPoint),
                                                               (BPoint,CPoint,b1Point,CPoint),
                                                               (DPoint,CPoint,d1Point,CPoint),
                                                               (FPoint,DPoint,FPoint,dPoint),
                                                               (DPoint,EPoint,DPoint,e1Point)]
        
        arrayOfDots.forEach { (a,b,c,d) in
            bezierPath.move(to: a)
            bezierPath.addCurve(to: b, controlPoint1: c, controlPoint2: d)
        }
        ctx.addPath(bezierPath.cgPath)
        ctx.setLineCap(.round)
        ctx.strokePath()
    }
    
}
