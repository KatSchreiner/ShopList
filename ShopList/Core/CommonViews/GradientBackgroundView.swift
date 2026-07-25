//
//  GradientBackgroundView.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 21.07.2026.
//

import UIKit

class GradientBackgroundView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    init(
        colors: [CGColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = .init(x: 0.5, y: 0.0),
        endPoint: CGPoint = .init(x: 0.5, y: 1.0)) {
        super.init(frame: .zero)
        setupGradientLayer(colors: colors, locations: locations, startPoint: startPoint, endPoint: endPoint)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradientLayer(
        colors: [CGColor],
        locations: [NSNumber]?,
        startPoint: CGPoint,
        endPoint: CGPoint
    ) {
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
