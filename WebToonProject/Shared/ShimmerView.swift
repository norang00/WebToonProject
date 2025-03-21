//
//  ShimmerView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/21/25.
//

import UIKit

final class ShimmerView: BaseView {
    private let gradientLayer = CAGradientLayer()
    
    override func configureView() {
        backgroundColor = UIColor.bgGray.withAlphaComponent(0.3)
        gradientLayer.colors = [
            UIColor.bgGray.cgColor,
            UIColor.white.cgColor,
            UIColor.bgGray.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        startShimmering()
    }
    
    static func apply(to view: UIView) -> ShimmerView {
        let shimmer = ShimmerView(frame: view.frame)
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shimmer)
        shimmer.snp.makeConstraints { $0.edges.equalToSuperview() }
        shimmer.startShimmering()
        return shimmer
    }
    
    func startShimmering() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func stopShimmering() {
        gradientLayer.removeAllAnimations()
        removeFromSuperview()
    }
}

