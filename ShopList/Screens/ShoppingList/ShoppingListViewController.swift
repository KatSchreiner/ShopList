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
        let gradientBackgroundView = GradientBackgroundView(
            colors: [UIColor.slBlue.cgColor, UIColor.white.cgColor],
            locations: [0.2, 0.5],
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0))
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return gradientBackgroundView
    }()
    
    private lazy var currentDayHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сегодня"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    private lazy var shoppingItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var showAddItemModalButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.accessibilityIdentifier = "AddItemModalTitle"
        button.backgroundColor = .slViolet
        button.layer.cornerRadius = Constants.cornerRadius
        button.addTarget(self, action: #selector(showAddItemModalButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "AddItemButton"
        return button
    }()
    
    private lazy var emptyStateImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "no_items_added"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = Constants.primaryColor
        
        label.text = "Хм… Пока тут тихо.\nНажмите кнопку, чтобы начать."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing =  10
        paragraphStyle.alignment = .center
        let attributedText = NSAttributedString(
            string: label.text ?? "",
            attributes: [.paragraphStyle: paragraphStyle])
        label.attributedText = attributedText
        return label
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - IB Actions
    @IBAction private func showAddItemModalButtonTapped() {
        let modalViewController = AddShoppingItemViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        present(modalViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, currentDayHeader, shoppingItemsTableView, showAddItemModalButton, emptyStateLabel, emptyStateImageView].forEach { view in
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
            
            showAddItemModalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAddItemModalButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            showAddItemModalButton.widthAnchor.constraint(equalToConstant: 200),
            showAddItemModalButton.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 30),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ShoppingListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomHalfPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
