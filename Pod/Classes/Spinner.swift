//
//  Spinner.swift
//  Pods
//
//  Created by Игорь Никитин on 05.02.16.
//
//

import UIKit

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
        setupWithConfiguration(configuration: configuration)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        configuration = Spinner.configuration
        super.init(coder: aDecoder)
        setupWithConfiguration(configuration: configuration)
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
        setupBackgroundViewWithConfiguration(configuration: configuration.backgroundViewConfiguration)
        setupIndicatorContainerWithConfiguration(configuration: configuration.containerViewConfiguration)
        setupIndicatorWithConfiguration(configuration: configuration.indicatorConfiguration)
        setupTitleWithConfiguration(configuration: configuration.titleConfiguration)
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
        indicatorContainer.layer.shadowColor = configuration.shadowColor.cgColor
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
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
    }
    
    // MARK: - Layout
    
    /*override public class func requiresConstraintBasedLayout() -> Bool {
        return true
    }*/
    
    override public func updateConstraints() {
        if !constraintsSettedUp {
            setupConstraints()
        }
        
        let spacing = configuration.containerViewConfiguration.spacing
        indicatorLabelSpaceConstraint?.constant = ((titleLabel.text?.count)!) > 0 ? spacing : 0
        
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
        indicatorContainer.widthAnchor.constraint(equalToConstant: width).isActive = true
        indicatorContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Indicator and label constraints
        let containerInsets = configuration.containerViewConfiguration.insets
        let spacing = configuration.containerViewConfiguration.spacing
        
        indicator.indicatorView.topAnchor.constraint(equalTo: indicatorContainer.topAnchor, constant:
            containerInsets.top).isActive = true
        indicatorContainer.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:
            containerInsets.bottom).isActive = true
        
        let spaceConstraint = titleLabel.topAnchor.constraint(
            equalTo: indicator.indicatorView.bottomAnchor, constant: spacing)
        spaceConstraint.isActive = true
        indicatorLabelSpaceConstraint = spaceConstraint
        
        let horizontalMetrics = ["left": containerInsets.left, "right": containerInsets.right]
        let horizontalViews = ["label": titleLabel, "indicator": indicator.indicatorView]
        let horizontalLabelConstraintsString = "H:|-left-[label]-right-|"
        let horizontalIndicatorConstraintsString = "H:|->=left-[indicator]->=right-|"
        
        let horizontalLabelConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: horizontalLabelConstraintsString, options: [], metrics: horizontalMetrics, views:
            horizontalViews as [String : Any])
        let horizontalIndicatorConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: horizontalIndicatorConstraintsString, options: [], metrics: horizontalMetrics, views:
            horizontalViews as [String : Any])
        
        NSLayoutConstraint.activate(horizontalLabelConstraints)
        NSLayoutConstraint.activate(horizontalIndicatorConstraints)
    }
    
    private func setupIndicatorConstraints() {
        let height = configuration.indicatorConfiguration.size.height
        let width = configuration.indicatorConfiguration.size.width
        
        let indicatorHeight = indicator.indicatorView.heightAnchor.constraint(equalToConstant: height)
        indicatorHeight.priority = UILayoutPriority(rawValue: 900)
        indicatorHeight.isActive = true
        
        let indicatorWidth = indicator.indicatorView.widthAnchor.constraint(equalToConstant: width)
        indicatorWidth.priority = UILayoutPriority(rawValue: 900)
        indicatorWidth.isActive = true
        
        indicator.indicatorView.centerXAnchor.constraint(
            equalTo: indicatorContainer.centerXAnchor).isActive = true
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
    
    public func showInView(view: UIView, withTitle title: String?) {
        self.titleLabel.text = title
        showInView(view: view)
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
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        scaleAnimation.repeatCount = 1
        animationStartTime = scaleAnimation.beginTime
        
        indicatorContainer.layer.add(scaleAnimation, forKey: "string")
    }
    
    private func animateBackground() {
        backgroundColor = .clear
        
        UIView.animate(
            withDuration: configuration.animationDuration,
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
        
        UIView.animate(
            withDuration: configuration.animationDuration,
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
    
    // MARK: - Touches
    
    // Currently don't allow touches
    /*override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self
    }*/
    
}
