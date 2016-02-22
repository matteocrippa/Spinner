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
    // spacing between indicator and label
    private var indicatorLabelSpaceConstraint: NSLayoutConstraint?
    private weak var boundingView: UIView?
    
    private var animationStartTime: CFTimeInterval?
    
    public let configuration: SpinnerConfiguration
    
    public private(set) var indicatorContainer: UIView!
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
        setupIndicatorContainerWithConfiguration(configuration.containerViewConfiguration)
        setupIndicatorWithConfiguration(configuration.indicatorConfiguration)
        setupTitleWithConfiguration(configuration.titleConfiguration)
    }
    
    private func setupBackgroundViewWithConfiguration(configuration:
        SpinnerConfiguration.BackgroundViewConfiguration) {
        backgroundColor = configuration.backgroundColor
    }
    
    private func setupIndicatorContainerWithConfiguration(configuration:
        SpinnerConfiguration.ContainerViewConfiguration) {
        indicatorContainer = UIView()
        addSubview(indicatorContainer)
        
        indicatorContainer.backgroundColor = configuration.backgroundColor
        
        indicatorContainer.layer.cornerRadius = configuration.cornerRadius
        indicatorContainer.layer.shadowColor = configuration.shadowColor.CGColor
        indicatorContainer.layer.shadowRadius = configuration.shadowRadius
        indicatorContainer.layer.shadowOpacity = configuration.shadowOpacity
        indicatorContainer.layer.shadowOffset = configuration.shadowOffset
    }
    
    private func setupIndicatorWithConfiguration(configuration:
        SpinnerConfiguration.IndicatorConfiguration) {
        indicator = configuration.indicator.init()
        indicatorContainer.addSubview(indicator.indicatorView)
    }
    
    private func setupTitleWithConfiguration(configuration: SpinnerConfiguration.TitleConfiguration) {
        titleLabel = UILabel()
        indicatorContainer.addSubview(titleLabel)
        
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
        
        let spacing = configuration.containerViewConfiguration.spacing
        indicatorLabelSpaceConstraint?.constant = titleLabel.text?.characters.count > 0 ? spacing : 0
        
        super.updateConstraints()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        guard let boundingFrame = boundingView?.bounds else {
            return
        }
        
        frame = boundingFrame
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        indicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        indicator.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupContainerConstraints()
        setupIndicatorConstraints()

        constraintsSettedUp = true
    }
    
    private func setupContainerConstraints() {
        let width = configuration.containerViewConfiguration.preferredWidth
        NSLayoutConstraint(item: indicatorContainer, attribute: .Width, relatedBy: .Equal, toItem:
            nil, attribute: .NotAnAttribute, multiplier: 1, constant: width).active = true
        NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem:
            indicatorContainer, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem:
            indicatorContainer, attribute: .CenterY, multiplier: 1, constant: 0).active = true
        
        // Indicator and label constraints
        let containerInsets = configuration.containerViewConfiguration.insets
        let spacing = configuration.containerViewConfiguration.spacing
        
        NSLayoutConstraint(item: indicator.indicatorView, attribute: .Top, relatedBy: .Equal, toItem:
            indicatorContainer, attribute: .Top, multiplier: 1, constant: containerInsets.top).active = true
        NSLayoutConstraint(item: indicatorContainer, attribute: .Bottom, relatedBy: .Equal, toItem:
            titleLabel, attribute: .Bottom, multiplier: 1, constant:
            containerInsets.bottom).active = true
        
        let spaceConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: indicator.indicatorView, attribute: .Bottom, multiplier: 1, constant: spacing)
        spaceConstraint.active = true
        indicatorLabelSpaceConstraint = spaceConstraint
        
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
        
        NSLayoutConstraint.activateConstraints(horizontalLabelConstraints)
        NSLayoutConstraint.activateConstraints(horizontalIndicatorConstraints)
    }
    
    private func setupIndicatorConstraints() {
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
            indicatorContainer, attribute: .CenterX, multiplier: 1, constant: 0).active = true
    }
    
    // MARK: - Visibility
    
    public func showInView(view: UIView) {
        view.addSubview(self)
        boundingView = view
        
        frame = view.bounds
        alpha = 1
        
        animateBackground()
        animateSpinnerContainer()
        indicator.beginAnimation()
    }
    
    public func showInView(view: UIView, withTitle title: String) {
        self.titleLabel.text = title
        showInView(view)
    }
    
    public func hide(completion: (() -> Void)? = nil) {
        animateHidingWithCompletion {
//            self.titleLabel.text = nil
            completion?()
        }
    }
    
    // MARK: - Animation
    
    private func animateSpinnerContainer() {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.beginTime = CACurrentMediaTime()
        scaleAnimation.values = [0, 1, 1.05, 1]
        scaleAnimation.duration = configuration.animationDuration
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.repeatCount = 1
        animationStartTime = scaleAnimation.beginTime
        
        indicatorContainer.layer.addAnimation(scaleAnimation, forKey: "string")
    }
    
    private func animateBackground() {
        backgroundColor = .clearColor()
        
        UIView.animateWithDuration(
            configuration.animationDuration,
            animations: {
                self.backgroundColor = self.configuration.backgroundViewConfiguration.backgroundColor
            }
        )
    }
    
    private func animateHidingWithCompletion(completion: (() -> Void)?) {
        let currentAnimationTime = CACurrentMediaTime()
        let delta = currentAnimationTime - (animationStartTime ?? 0.0)
        let delay = delta > configuration.minimumVisibleTime ? 0 :
            abs(configuration.minimumVisibleTime - delta)
        
        UIView.animateWithDuration(
            configuration.animationDuration,
            delay: delay,
            options: [],
            animations: {
                self.alpha = 0
            },
            completion:  {
                _ in
                self.removeFromSuperview()
                self.frame = CGRect.zero
                self.boundingView = nil
                completion?()
            }
        )
    }
    
}