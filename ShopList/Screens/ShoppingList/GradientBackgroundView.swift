//
//  GradientBackgroundView.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 21.07.2026.
//

import UIKit

class GradientBackgroundView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.slBlue.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.2, 0.6]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
