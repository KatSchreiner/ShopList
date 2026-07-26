//
//  BottomHalfPresentationController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 26.07.2026.
//

import UIKit

class BottomHalfPresentationController: UIPresentationController {
    private var maskLayer: CALayer?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let height = container.bounds.height * 0.5
        return CGRect(
            x: 0,
            y: container.bounds.height - height,
            width: container.bounds.width,
            height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
        createMaskLayer()
    }
    
    private func createMaskLayer() {
        guard let presentedView = presentedView else { return }
        
        if maskLayer == nil {
            maskLayer = CALayer()
            presentedView.layer.mask = maskLayer
        }
        
        guard let mask = maskLayer else { return }
        mask.frame = presentedView.bounds
        
        let path = UIBezierPath(
            roundedRect: mask.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: 24, height: 24)
        )
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        
        mask.contents = shapeLayer.contents
        mask.sublayers = [shapeLayer]
    }
}
