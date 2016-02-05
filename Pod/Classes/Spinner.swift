//
//  Spinner.swift
//  Pods
//
//  Created by Игорь Никитин on 05.02.16.
//
//

import UIKit

// Currently supports only one device orientation
// Subscribe to device orientation change notification
public class Spinner: UIView {
    
    // MARK: - Default Configuration
    
    public static var configuration = SpinnerConfiguration()
    
    // MARK: - Properties
    private var spinnerContainer: UIView!
    private var indicator: SpinnerIndicator!
    
    private var animationStartTime: CFTimeInterval?
    
    // MARK: - Initialization
    
    public init(frame: CGRect, configuration: SpinnerConfiguration) {
        super.init(frame: frame)
        setupWithConfiguration(configuration)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupWithConfiguration(Spinner.configuration)
    }
    
    override public convenience init(frame: CGRect) {
        self.init(frame: frame, configuration: Spinner.configuration)
    }
    
    public convenience init(configuration: SpinnerConfiguration) {
        self.init(frame: .zero, configuration: configuration)
    }
    
    // MARK: - Setup
    
    private func setupWithConfiguration(configuration: SpinnerConfiguration) {
        setupBackgroundViewWithConfiguration(configuration.backgroundViewConfiguration)
        setupSpinnerContainerWithConfiguration(configuration.spinnerViewConfiguration)
        setupIndicatorWithConfiguration(configuration.indicatorConfiguration)
    }
    
    private func setupBackgroundViewWithConfiguration(configuration:
        SpinnerConfiguration.BackgroundViewConfiguration) {
        backgroundColor = configuration.backgroundColor
    }
    
    private func setupSpinnerContainerWithConfiguration(configuration:
        SpinnerConfiguration.ContainerViewConfiguration) {
        spinnerContainer = UIView()
        
        spinnerContainer.layer.cornerRadius = configuration.cornerRadius
        
        spinnerContainer.layer.shadowColor = configuration.shadowColor.CGColor
        spinnerContainer.layer.shadowRadius = configuration.shadowRadius
        spinnerContainer.layer.shadowOpacity = configuration.shadowOpacity
        spinnerContainer.layer.shadowOffset = configuration.shadowOffset
    }
    
    private func setupIndicatorWithConfiguration(configuration:
        SpinnerConfiguration.IndicatorConfiguration) {
        indicator = configuration.indicator.init()
        
        let frame = CGRect(origin: CGPoint.zero, size: configuration.size)
        indicator.indicatorView.frame = frame
    }
    
    // MARK: - Visibility
    
//    func show() {
//        guard let window = UIApplication.sharedApplication().keyWindow else {
//            return
//        }
//        
//        window.addSubview(self)
//        
//        frame = window.bounds
//        alpha = 1
//        
//        spinnerView.alpha = 0
//        
//        animateSpinnerContainer()
//        animateBackground()
//    }
//    
//    func showWithTitle(title: String?) {
//        self.title = title
//        show()
//    }
//    
//    func hide(completion: (() -> Void)?) {
//        animateHidingWithCompletion(completion)
//    }
//    
//    // MARK: - Animation
//    
//    private func animateSpinnerContainer() {
//        CATransaction.begin()
//        
//        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
//        scaleAnimation.beginTime = CACurrentMediaTime()
//        scaleAnimation.values = [0, 1, 1.05, 1]
//        scaleAnimation.keyTimes = [0, 0.7, 0.85, 1]
//        scaleAnimation.duration = animationDuration
//        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        scaleAnimation.calculationMode = kCAAnimationPaced
//        scaleAnimation.repeatCount = 1
//        
//        animationStartTime = scaleAnimation.beginTime
//        
//        CATransaction.setCompletionBlock {
//            self.animateSpinnerIndicator()
//        }
//        
//        indicatorContainer.layer.addAnimation(scaleAnimation, forKey: "string")
//        
//        CATransaction.commit()
//    }
//    
//    private func animateSpinnerIndicator() {
//        self.spinnerView.beginAnimation()
//        UIView.animateWithDuration(
//            secondaryAnimationDuration,
//            animations: {
//                self.spinnerView.alpha = 1
//            }
//        )
//    }
//    
//    private func animateBackground() {
//        backgroundColor = .clearColor()
//        
//        UIView.animateWithDuration(
//            animationDuration,
//            animations: {
//                self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
//            }
//        )
//    }
//    
//    private func animateHidingWithCompletion(completion: (() -> Void)?) {
//        let currentAnimationTime = CACurrentMediaTime()
//        let delta = currentAnimationTime - (animationStartTime ?? 0.0)
//        let delay = delta > minimumVisibleTime ? 0 : abs(minimumVisibleTime - delta)
//        
//        UIView.animateWithDuration(
//            secondaryAnimationDuration,
//            delay: delay,
//            options: [],
//            animations: {
//                self.alpha = 0
//            },
//            completion:  {
//                _ in
//                self.removeFromSuperview()
//                self.frame = CGRect.zero
//                completion?()
//            }
//        )
//    }
    
}