//
//  UIView.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 26.07.2026.
//
import UIKit

extension UIView {
    func fadeIn(
        duration: TimeInterval = 0.3,
        alpha: CGFloat = 1.0,
        options: UIView.AnimationOptions = [
            .curveEaseOut,
            .beginFromCurrentState,
            .allowUserInteraction
        ],
        completion: ((Bool) -> Void)? = nil
    ) {
        isHidden = false
        self.alpha = 0
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                self.alpha = alpha
            },
            completion: completion
        )
    }
    
    func fadeOut(
        duration: TimeInterval = 0.3,
        options: UIView.AnimationOptions = [
            .curveEaseOut,
            .beginFromCurrentState,
            .allowUserInteraction
        ],
        hideAfterAnimation: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                self.alpha = 0
            },
            completion: { finished in
                if hideAfterAnimation {
                    self.isHidden = true
                }
                
                completion?(finished)
            }
        )
    }
    
    func scaleDownAnimation(
        scale: CGFloat = 0.9,
        duration: TimeInterval = 0.1,
        options: UIView.AnimationOptions = [
            .curveEaseInOut,
            .beginFromCurrentState,
            .allowUserInteraction
        ],
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                self.transform = CGAffineTransform(
                    scaleX: scale,
                    y: scale
                )
            },
            completion: { _ in
                UIView.animate(
                    withDuration: duration,
                    delay: 0,
                    options: options,
                    animations: {
                        self.transform = .identity
                    },
                    completion: { _ in
                        completion?()
                    }
                )
            }
        )
    }
    
    func startPulse(
        scale: CGFloat = 1.15,
        duration: TimeInterval = 0.6
    ) {
        stopPulse()
        
        let animation = CABasicAnimation(
            keyPath: "transform.scale"
        )
        
        animation.fromValue = 1.0
        animation.toValue = scale
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(
            name: .easeInEaseOut
        )
        
        layer.add(animation, forKey: "pulseAnimation")
    }
    
    func stopPulse() {
        layer.removeAnimation(forKey: "pulseAnimation")
    }
}
