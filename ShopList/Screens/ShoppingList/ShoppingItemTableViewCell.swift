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
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: ShoppingItem) {
        titleLabel.text = item.title
        print("Текст: \\(titleLabel.text)")
        print("Размеры label: \\(titleLabel.bounds)")
    }
    
    private func setupView() {
        containerView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        
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
}
