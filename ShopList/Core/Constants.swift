//
//  Constants.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

class Constants {
    static let primaryColor: UIColor = .slDarkBlue
    static let accentColor: UIColor = .slViolet
    static let backgroundColor: UIColor = .slWhite
    static let labelColor: UIColor = .slWhite
    
    static let cornerRadius: CGFloat = 15
    
    static let smallSpacing: CGFloat = 8
    static let defaultSpacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24
    
    static let titleFont: UIFont = .preferredFont(forTextStyle: .headline)
    static let bodyFont: UIFont = .preferredFont(forTextStyle: .body)
    static let captionFont: UIFont = .preferredFont(forTextStyle: .caption1)
    
    static let directionOfGradient: (start: CGPoint, end: CGPoint) = (
        start: CGPoint(x: 0.5, y: 0.0),
        end: CGPoint(x: 0.5, y: 1.0))
    
    static let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
}
