//
//  CircleIndicator.swift
//  Pods
//
//  Created by Игорь Никитин on 05.02.16.
//
//

import UIKit

@IBDesignable
public class CircleIndicator: UIView {
    
    private let circleLayer = CAShapeLayer()
    
    // MARK: - Customization
    
    @IBInspectable public var lineWidth: CGFloat = 5 {
        didSet {
            circleLayer.lineWidth = lineWidth
        }
    }
    
    @IBInspectable public var lineCap: String = kCALineCapRound {
        didSet {
            circleLayer.lineCap = lineCap
        }
    }
    
    @IBInspectable public var lineColor = UIColor.mainRedColor {
        didSet {
            circleLayer.strokeColor = lineColor.cgColor
        }
    }
    
    @IBInspectable public var innerColor = UIColor.clear {
        didSet {
            circleLayer.fillColor = innerColor.cgColor
        }
    }
    
    @IBInspectable public var lineStart: CGFloat = 0.1 {
        didSet {
            circleLayer.strokeStart = lineStart
        }
    }
    
    @IBInspectable public var lineEnd: CGFloat = 0.9 {
        didSet {
            circleLayer.strokeEnd = lineEnd
        }
    }
    
    @IBInspectable public var revolutionDuration = 1.0
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureLayers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureLayers()
    }
    
    private func configureLayers() {
        layer.addSublayer(circleLayer)
        
        circleLayer.fillColor = innerColor.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.lineCap = lineCap
        circleLayer.strokeColor = lineColor.cgColor
        circleLayer.strokeStart = lineStart
        circleLayer.strokeEnd = lineEnd
    }
    
    // MARK: - Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        circleLayer.frame = bounds
        circleLayer.path = spinnerPathWithRect(rect: bounds)
    }
    
    private func spinnerPathWithRect(rect: CGRect) -> CGPath {
        let minimumSide = min(rect.width, rect.height)
        let originX = rect.width / 2 - minimumSide / 2 + lineWidth / 2
        let originY = rect.height / 2 - minimumSide / 2 + lineWidth / 2
        let side = minimumSide - lineWidth
        let spinnerRect = CGRect(x: originX, y: originY, width: side, height: side)
        
        return UIBezierPath(ovalIn: spinnerRect).cgPath
    }
    
    // MARK: - Animation
    
    public func beginAnimation() {
        circleLayer.removeAllAnimations()
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.byValue = 2 * M_PI
        rotationAnimation.duration = revolutionDuration
        rotationAnimation.repeatCount = Float.infinity
        
        circleLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    public func endAnimation() {
        circleLayer.removeAllAnimations()
    }
    
}

extension CircleIndicator: SpinnerIndicator { }
