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
    
    private let configuration: SpinnerConfiguration
    private var constraintsSettedUp = false
    private var animationStartTime: CFTimeInterval?
    
    private(set) var spinnerContainer: UIView!
    private(set) var indicator: SpinnerIndicator!
    private(set) var titleLabel: UILabel!
    
    // MARK: - Initialization
    
    public init(frame: CGRect, configuration: SpinnerConfiguration) {
        self.configuration = configuration
        super.init(frame: frame)
        setupWithConfiguration(configuration)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        configuration = Spinner.configuration
        super.init(coder: aDecoder)
        setupWithConfiguration(configuration)
    }
    
    override public convenience init(frame: CGRect) {
        self.init(frame: frame, configuration: Spinner.configuration)
    }
    
    public convenience init(configuration: SpinnerConfiguration) {
        self.init(frame: .zero, configuration: configuration)
    }
    
    public convenience init() {
        self.init(frame: .zero, configuration: Spinner.configuration)
    }
    
    // MARK: - Setup
    
    private func setupWithConfiguration(configuration: SpinnerConfiguration) {
        setupBackgroundViewWithConfiguration(configuration.backgroundViewConfiguration)
        setupSpinnerContainerWithConfiguration(configuration.spinnerViewConfiguration)
        setupIndicatorWithConfiguration(configuration.indicatorConfiguration)
        setupTitleWithConfiguration(configuration.titleConfiguration)
        
        #if !NDEBUG
            let tapRecognizer = UITapGestureRecognizer(target: self, action: "hide")
            spinnerContainer.addGestureRecognizer(tapRecognizer)
        #endif
    }
    
    private func setupBackgroundViewWithConfiguration(configuration:
        SpinnerConfiguration.BackgroundViewConfiguration) {
        backgroundColor = configuration.backgroundColor
    }
    
    private func setupSpinnerContainerWithConfiguration(configuration:
        SpinnerConfiguration.ContainerViewConfiguration) {
        spinnerContainer = UIView()
        addSubview(spinnerContainer)
        
        spinnerContainer.backgroundColor = configuration.backgroundColor
        
        spinnerContainer.layer.cornerRadius = configuration.cornerRadius
        spinnerContainer.layer.shadowColor = configuration.shadowColor.CGColor
        spinnerContainer.layer.shadowRadius = configuration.shadowRadius
        spinnerContainer.layer.shadowOpacity = configuration.shadowOpacity
        spinnerContainer.layer.shadowOffset = configuration.shadowOffset
    }
    
    private func setupIndicatorWithConfiguration(configuration:
        SpinnerConfiguration.IndicatorConfiguration) {
        indicator = configuration.indicator.init()
        spinnerContainer.addSubview(indicator.indicatorView)
    }
    
    private func setupTitleWithConfiguration(configuration: SpinnerConfiguration.TitleConfiguration) {
        titleLabel = UILabel()
        spinnerContainer.addSubview(titleLabel)
        
        titleLabel.font = configuration.font
        titleLabel.textColor = configuration.color
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
    }
    
    // MARK: - Layout
    
    override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override public func updateConstraints() {
        if !constraintsSettedUp {
            setupConstraints()
        }
        
        super.updateConstraints()
    }
    
    private func setupConstraints() {
        spinnerContainer.translatesAutoresizingMaskIntoConstraints = false
        indicator.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Self constraints
        NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem:
            spinnerContainer, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem:
            spinnerContainer, attribute: .CenterY, multiplier: 1, constant: 0).active = true
        
        // Spinner container constraints
        NSLayoutConstraint(item: spinnerContainer, attribute: .Width, relatedBy: .Equal, toItem:
            nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200).active = true
        
        // Indicator constraints
        NSLayoutConstraint(item: indicator.indicatorView, attribute: .Height, relatedBy: .Equal, toItem:
            nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30).active = true
        NSLayoutConstraint(item: indicator.indicatorView, attribute: .Width, relatedBy: .Equal, toItem:
            nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30).active = true
        NSLayoutConstraint(item: indicator.indicatorView, attribute: .CenterX, relatedBy: .Equal, toItem:
            spinnerContainer, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        
        // Indicator and label constraints
        let verticalMetrics = ["top": 20, "middle": 20, "bottom": 20]
        let verticalViews = ["indicator": indicator.indicatorView, "label": titleLabel]
        let verticalConstraintsString = "V:|-top-[indicator]-middle-[label]-bottom-|"
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            verticalConstraintsString, options: [], metrics: verticalMetrics, views: verticalViews)
        
        let horizontalMetrics = ["left": 20, "right": 20]
        let horizontalViews = ["label": titleLabel]
        let horizontalConstraintsString = "H:|-left-[label]-right-|"
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            horizontalConstraintsString, options: [], metrics: horizontalMetrics, views:
            horizontalViews)
        
        NSLayoutConstraint.activateConstraints(verticalConstraints)
        NSLayoutConstraint.activateConstraints(horizontalConstraints)
        
        constraintsSettedUp = true
    }
    
    // MARK: - Visibility
    
    public func show() {
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        
        window.addSubview(self)
        
        frame = window.bounds
        alpha = 1
        
        indicator.indicatorView.alpha = 0
        
        animateSpinnerContainer()
        animateBackground()
    }
    
    public func showWithTitle(title: String?) {
        self.titleLabel.text = title
        show()
    }
    
    func hide(completion: (() -> Void)?) {
        animateHidingWithCompletion {
            self.titleLabel.text = nil
            completion?()
        }
    }
    
    #if !NDEBUG
    func hide() {
        hide(nil)
    }
    #endif
    
    // MARK: - Animation
    
    private func animateSpinnerContainer() {
        CATransaction.begin()
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.beginTime = CACurrentMediaTime()
        scaleAnimation.values = [0, 1, 1.1, 1]
        scaleAnimation.duration = configuration.animationDuration
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.calculationMode = kCAAnimationPaced
        scaleAnimation.repeatCount = 1
        
        animationStartTime = scaleAnimation.beginTime
        
        CATransaction.setCompletionBlock {
            self.animateSpinnerIndicator()
        }
        
        spinnerContainer.layer.addAnimation(scaleAnimation, forKey: "string")
        
        CATransaction.commit()
    }
    
    private func animateSpinnerIndicator() {
        self.indicator.beginAnimation()
        UIView.animateWithDuration(
            configuration.secondaryAnimationDuration,
            animations: {
                self.indicator.indicatorView.alpha = 1
            }
        )
    }
    
    private func animateBackground() {
        backgroundColor = .clearColor()
        
        UIView.animateWithDuration(
            configuration.animationDuration,
            animations: {
                self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            }
        )
    }
    
    private func animateHidingWithCompletion(completion: (() -> Void)?) {
        let currentAnimationTime = CACurrentMediaTime()
        let delta = currentAnimationTime - (animationStartTime ?? 0.0)
        let delay = delta > configuration.minimumVisibleTime ? 0 :
            abs(configuration.minimumVisibleTime - delta)
        
        UIView.animateWithDuration(
            configuration.secondaryAnimationDuration,
            delay: delay,
            options: [],
            animations: {
                self.alpha = 0
            },
            completion:  {
                _ in
                self.removeFromSuperview()
                self.frame = CGRect.zero
                completion?()
            }
        )
    }
    
}