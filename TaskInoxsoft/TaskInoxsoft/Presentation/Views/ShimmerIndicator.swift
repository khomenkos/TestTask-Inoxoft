//
//  ShimmerIndicator.swift
//  TaskInoxsoft
//
//  Created by Oлександр Хоменко on 18.02.2026.
//

import UIKit
import Kingfisher

public struct ShimmerIndicator: Indicator {
    public let view: IndicatorView = UIView()
    
    public init() {
        view.backgroundColor = .systemGray5
    }

    public func startAnimatingView() {
        view.isHidden = false
        
        let gradientColorOne = UIColor.systemGray5.cgColor
        let gradientColorTwo = UIColor.systemGray4.cgColor
        let gradientColorThree = UIColor.systemGray5.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorThree]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.frame = CGRect(x: -1000, y: -1000, width: 4000, height: 4000)
        gradientLayer.name = "shimmerLayer"
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.2
        
        view.clipsToBounds = true
        gradientLayer.add(animation, forKey: "shimmerAnimation")
        view.layer.addSublayer(gradientLayer)
    }

    public func stopAnimatingView() {
        view.isHidden = true
        view.layer.sublayers?.filter { $0.name == "shimmerLayer" }.forEach { $0.removeFromSuperlayer() }
    }
}
