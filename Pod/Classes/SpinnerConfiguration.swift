//
//  SpinnerConfiguration.swift
//  Pods
//
//  Created by Игорь Никитин on 05.02.16.
//
//

import Foundation

public struct SpinnerConfiguration {
    
    public var backgroundViewConfiguration = BackgroundViewConfiguration()
    public var containerViewConfiguration = ContainerViewConfiguration()
    public var indicatorConfiguration = IndicatorConfiguration()
    public var titleConfiguration = TitleConfiguration()
    
    // MARK: - Animation
    
    public var animationDuration = 0.3
//    public var secondaryAnimationDuration = 0.2
    
    // MARK: - Visibility
    
    public var minimumVisibleTime = 1.0
    
}

public extension SpinnerConfiguration {
    
    // MARK: - Inner Configuration Structures
    
    public struct BackgroundViewConfiguration {
        
        public var backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
    }
    
    public struct ContainerViewConfiguration {
        
        public var backgroundColor = UIColor.white
        public var cornerRadius: CGFloat = 5
        
        public var shadowOffset = CGSize.zero
        public var shadowRadius: CGFloat = 5
        public var shadowOpacity: Float = 0.5
        public var shadowColor = UIColor.black
        
        public var insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        public var spacing: CGFloat = 20
        public var preferredWidth: CGFloat = 200
        
    }
    
    public struct IndicatorConfiguration {
        
        public var indicator: SpinnerIndicator.Type = CircleIndicator.self
        public var size = CGSize(width: 50, height: 50)
        
    }
    
    public struct TitleConfiguration {
        
        public var font = UIFont.systemFont(ofSize: 14)
        public var color = UIColor.black
        
    }
    
}

