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
    
    private var constraintsSettedUp = false
    private var animationStartTime: CFTimeInterval?
    
    public let configuration: SpinnerConfiguration
    
    public private(set) var spinnerContainer: UIView!
    public private(set) var indicator: SpinnerIndicator!
    public private(set) var titleLabel: UILabel!
    
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
        setupSpinnerContainerWithConfiguration(configuration.containerViewConfiguration)
        setupIndicatorWithConfiguration(configuration.indicatorConfiguration)
        setupTitleWithConfiguration(configuration.titleConfiguration)
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
        let width = configuration.containerViewConfiguration.preferredWidth
        NSLayoutConstraint(item: spinnerContainer, attribute: .Width, relatedBy: .Equal, toItem:
            nil, attribute: .NotAnAttribute, multiplier: 1, constant: width).active = true
        
        // Indicator constraints
        let indicatorSize = configuration.indicatorConfiguration.size
        let indicatorHeight = NSLayoutConstraint(item: indicator.indicatorView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant:
            indicatorSize.height)
        indicatorHeight.priority = 900
        indicatorHeight.active = true
        
        let indicatorWidth = NSLayoutConstraint(item: indicator.indicatorView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant:
            indicatorSize.width)
        indicatorWidth.priority = 900
        indicatorWidth.active = true
        
        NSLayoutConstraint(item: indicator.indicatorView, attribute: .CenterX, relatedBy: .Equal, toItem:
            spinnerContainer, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        
        // Indicator and label constraints
        let containerInsets = configuration.containerViewConfiguration.insets
        let spacing = configuration.containerViewConfiguration.spacing
        let verticalMetrics = [
            "top": containerInsets.top, "space": spacing, "bottom": containerInsets.bottom
        ]
        let verticalViews = ["indicator": indicator.indicatorView, "label": titleLabel]
        let verticalConstraintsString = "V:|-top-[indicator]-space-[label]-bottom-|"
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            verticalConstraintsString, options: [], metrics: verticalMetrics, views: verticalViews)
        
        let horizontalMetrics = ["left": containerInsets.left, "right": containerInsets.right]
        let horizontalViews = ["label": titleLabel, "indicator": indicator.indicatorView]
        let horizontalLabelConstraintsString = "H:|-left-[label]-right-|"
        let horizontalIndicatorConstraintsString = "H:|->=left-[indicator]->=right-|"
        
        let horizontalLabelConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            horizontalLabelConstraintsString, options: [], metrics: horizontalMetrics, views:
            horizontalViews)
        let horizontalIndicatorConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            horizontalIndicatorConstraintsString, options: [], metrics: horizontalMetrics, views:
            horizontalViews)
        
        NSLayoutConstraint.activateConstraints(verticalConstraints)
        NSLayoutConstraint.activateConstraints(horizontalLabelConstraints)
        NSLayoutConstraint.activateConstraints(horizontalIndicatorConstraints)
        
        constraintsSettedUp = true
    }
    
    // MARK: - Visibility
    
    public func showInView(view: UIView) {
        view.addSubview(self)
        
        frame = view.bounds
        alpha = 1
        
        indicator.indicatorView.alpha = 0
        
        animateSpinnerContainer()
        animateBackground()
    }
    
    public func showInView(view: UIView, withTitle title: String) {
        self.titleLabel.text = title
        showInView(view)
    }
    
    func hide(completion: (() -> Void)?) {
        animateHidingWithCompletion {
            self.titleLabel.text = nil
            completion?()
        }
    }
    
    // MARK: - Animation
    
    private func animateSpinnerContainer() {
//        CATransaction.begin()
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.beginTime = CACurrentMediaTime()
        scaleAnimation.values = [0, 1, 1.1, 1]
        scaleAnimation.duration = configuration.animationDuration
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.calculationMode = kCAAnimationPaced
        scaleAnimation.repeatCount = 1
        
        animationStartTime = scaleAnimation.beginTime
//        
//        CATransaction.setCompletionBlock {
//            self.animateSpinnerIndicator()
//        }
        
        spinnerContainer.layer.addAnimation(scaleAnimation, forKey: "string")
        
//        CATransaction.commit()
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