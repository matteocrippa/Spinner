//
//  SpinnerIndicator.swift
//  Pods
//
//  Created by Игорь Никитин on 05.02.16.
//
//

public protocol SpinnerIndicator {
    
    var indicatorView: UIView { get }
    
    func beginAnimation()
    func endAnimation()
    
    init()
    
}

extension SpinnerIndicator where Self: UIView {
    
    public var indicatorView: UIView {
        return self
    }
    
}
