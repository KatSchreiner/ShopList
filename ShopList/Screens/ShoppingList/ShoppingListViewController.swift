//
//  ViewController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var gradientBackground: GradientBackgroundView = {
        let gradientBackgroundView = GradientBackgroundView()
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return gradientBackgroundView
    }()
    
    private lazy var currentDayHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сегодня"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private lazy var shoppingItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        return tableView
    }()
    
    private lazy var showAddItemModalButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .slViolet
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, currentDayHeader, shoppingItemsTableView, showAddItemModalButton].forEach { view in
            self.view.addSubview(view)
        }
        
        setupConstraint()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            currentDayHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentDayHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            shoppingItemsTableView.topAnchor.constraint(equalTo: currentDayHeader.bottomAnchor, constant: 20),
            shoppingItemsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            shoppingItemsTableView.bottomAnchor.constraint(equalTo: showAddItemModalButton.topAnchor),
            shoppingItemsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            showAddItemModalButton.topAnchor.constraint(equalTo: shoppingItemsTableView.bottomAnchor, constant: 20),
            showAddItemModalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAddItemModalButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showAddItemModalButton.widthAnchor.constraint(equalToConstant: 200),
            showAddItemModalButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
