//
//  UIView.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 26.07.2026.
//
import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval = 0.3, alpha: CGFloat = 1.0, options: UIView.AnimationOptions = .curveEaseOut, completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0.0
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            animations: { self.alpha = alpha },
            completion: completion
        )
    }
    
    func fadeOut(duration: TimeInterval = 0.3, options: UIView.AnimationOptions = .curveEaseOut, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            animations: { self.alpha = 0.0 },
            completion: completion
        )
    }
    
    func scaleDownAnimation() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.transform = .identity
                    })
            })
    }
}
