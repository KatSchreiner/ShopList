//
//  ShoppingItemTableViewCell.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 30.07.2026.
//

import UIKit

class ShoppingItemTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShoppingItemTableViewCell"
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .slLightBlue
        view.layer.cornerRadius = Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let gradientBorderLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.slBlue.cgColor, UIColor.slYellow.cgColor, UIColor.slViolet.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.locations = [0.0, 0.5, 1.0]
        return layer
    }()
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 2
        return layer
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.bodyFont
        label.textColor = Constants.primaryColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ShoppingItem) {
        titleLabel.text = item.title
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.layer.insertSublayer(gradientBorderLayer, at: 0)
        gradientBorderLayer.mask = shapeLayer

        addConstraint()
    }
    
    private func addConstraint() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func updateGradientBorder() {
        gradientBorderLayer.frame = containerView.bounds
        
        let path = UIBezierPath(
            roundedRect: containerView.bounds,
            byRoundingCorners: [.allCorners],
            cornerRadii: CGSize(
                width: Constants.cornerRadius,
                height: Constants.cornerRadius)
        )
        shapeLayer.path = path.cgPath
    }
}
