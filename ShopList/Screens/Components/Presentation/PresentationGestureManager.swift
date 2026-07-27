//
//  PresentationGestureManager.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 27.07.2026.
//

import UIKit

protocol PresentationGestureDelegate: AnyObject {
    func didRequestDismiss()
}

class PresentationGestureManager: NSObject, UIGestureRecognizerDelegate {
    private var tapGesture: UITapGestureRecognizer?
    private var swipeGesture: UISwipeGestureRecognizer?
    
    weak var delegate: PresentationGestureDelegate?
    
    @objc private func handleTap() {
        delegate?.didRequestDismiss()
    }
    
    @objc private func handleSwipe() {
        delegate?.didRequestDismiss()
    }
    
    func setupTap(on view: UIView) {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        guard let gesture = tapGesture else { return }
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
    }
    
    func setupSwipe(on view: UIView) {
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        
        guard let gesture = swipeGesture else { return }
        gesture.direction = .down
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
