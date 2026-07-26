//
//  BottomHalfPresentationController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 26.07.2026.
//

import UIKit

class BottomHalfPresentationController: UIPresentationController {
    // MARK: - Private Properties
    private var maskLayer: CALayer?
    private weak var dimmingView: UIView?
    private var didSetupDimming = false
    
    // MARK: - Override Methods
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
        setupDimmingView()
        updateDimmingFrame()
    }
    
    @objc private func dismissOnTap() {
        guard let dimming = dimmingView else {
            presentingViewController.dismiss(animated: true)
            return
        }
        
        dimming.isUserInteractionEnabled = false
        dimming.fadeOut(duration: 0.3) { _ in
            self.presentingViewController.dismiss(animated: false)
        }
    }
    
    // MARK: Private Methods
    private func setupDimmingView() {
        guard !didSetupDimming, let container = containerView else { return }
        didSetupDimming = true
        
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.alpha = 0
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = container.bounds
        
        container.insertSubview(view, at: 0)
        dimmingView = view
        
        view.fadeIn(duration: 0.3, alpha: 0.5, options: .curveEaseInOut)

        addTapGestureRecognizer(to: view)
    }
    
    private func updateDimmingFrame() {
        dimmingView?.frame = containerView?.bounds ?? .zero
    }
    
    private func addTapGestureRecognizer(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOnTap))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
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
        
        mask.sublayers = [shapeLayer]
    }
}
