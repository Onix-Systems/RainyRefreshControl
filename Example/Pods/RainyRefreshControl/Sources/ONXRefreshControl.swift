//
//  BaseRefreshControl.swift
//  BaseRefreshControl
//

import UIKit

public class ONXRefreshControl: UIControl {
    
    private var forbidsOffsetChanges = false
    private var forbidsInsetChanges = false
    private var changingInset = false
    private var refreshing = false
    private var contentInset: UIEdgeInsets?
    public var animationDuration = TimeInterval(0.33)
    public var animationDamping = CGFloat(0.4)
    public var animationVelocity = CGFloat(0.8)
    //delay for finishing custom animation
    public var delayBeforeEnd = 0.0
    
    private var expandedHeight: CGFloat {
        return UIScreen.main.bounds.height / 6
    }

    // MARK: Initialization

    public convenience init() {
        self.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    deinit {
        if let superview = superview as? UIScrollView {
            superview.removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    // MARK: Superview handling
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if let superview = superview as? UIScrollView {
            superview.removeObserver(self, forKeyPath: "contentOffset")
        }
        super.willMove(toSuperview: newSuperview)
    }
    
    public override func didMoveToSuperview() {
        if let superview = superview as? UIScrollView {
            superview.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        }
        super.didMoveToSuperview()
    }

    // MARK: Refresh methods

    public func beginRefreshing() {
        guard let superview = superview as? UIScrollView, !refreshing else { return }
        refreshing = true
        
        //Saving inset
        contentInset = superview.contentInset
        let currentOffset = superview.contentOffset
        
        //Setting new inset
        changingInset = true
        var inset = superview.contentInset
        inset.top = inset.top + expandedHeight
        superview.contentInset = inset
        changingInset = false
        
        //Aaaaand scrolling
        superview.setContentOffset(currentOffset, animated: false)
        superview.setContentOffset(CGPoint(x: 0, y: -inset.top), animated: true)
        forbidsOffsetChanges = true
        didBeginRefresh()
    }
    
    public func endRefreshing() {
        guard let superview = superview as? UIScrollView, refreshing else { return }
        forbidsOffsetChanges = false
        refreshing = false
        self.willEndRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + delayBeforeEnd) {
            UIView.animate(withDuration: self.animationDuration,
                           delay: 0,
                           usingSpringWithDamping: self.animationDamping,
                           initialSpringVelocity: self.animationVelocity,
                           options: UIView.AnimationOptions.curveLinear,
                           animations: { () -> Void in
                            if let contentInset = self.contentInset {
                                superview.contentInset = contentInset
                                self.contentInset = nil
                            }
                            
            }) { (finished) -> Void in
                self.didEndRefresh()
            }
        }
    }
    
    // MARK: KVO
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let superview = superview as? UIScrollView, !changingInset else { return }
        //Updating frame
        let topInset = (contentInset ?? superview.contentInset).top
        let originY = superview.contentOffset.y + topInset
        let height = originY
        
        frame = CGRect(origin: CGPoint(x: 0, y: originY),
                       size: CGSize(width: superview.frame.width, height: -height))
        layout()
        //Detecting refresh gesture
        if superview.contentOffset.y + topInset <= -expandedHeight {
            forbidsInsetChanges = true
        } else if !refreshing {
            forbidsInsetChanges = false
        }
        
        if !superview.isDragging && superview.isDecelerating && !forbidsOffsetChanges && forbidsInsetChanges {
            sendActions(for: .valueChanged)
            beginRefreshing()
        }
    }

    open func setup() { }
    open func layout() { }
    open func willBeginRefresh() { }
    open func didBeginRefresh() { }
    open func willEndRefresh() { }
    open func didEndRefresh() { }
}
