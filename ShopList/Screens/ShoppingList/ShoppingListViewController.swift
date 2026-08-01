//
//  ViewController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

final class ShoppingListViewController: UIViewController {
    
    // MARK: - Private Properties
    let viewModel = ShoppingListViewModel()
    
    private lazy var gradientBackground: GradientBackgroundView = {
        let gradientBackgroundView = GradientBackgroundView(
            colors: [UIColor.slBlue.cgColor, UIColor.slWhite.cgColor],
            locations: [0.2, 0.5],
            startPoint: Constants.directionOfGradient.start,
            endPoint: Constants.directionOfGradient.end)
        return gradientBackgroundView
    }()
    
    private lazy var currentDayHeader: UILabel = {
        let label = UILabel()
        label.text = "Сегодня"
        label.textAlignment = .center
        label.font = Constants.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    private lazy var shoppingItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.accessibilityIdentifier = "ShoppingItemsTableView"
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.backgroundColor = Constants.backgroundColor
        tableView.separatorStyle = .none
        tableView.contentInset.top = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ShoppingItemTableViewCell.self, forCellReuseIdentifier: ShoppingItemTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var showAddItemModalButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Добавить", for: .normal)
        button.titleLabel?.font = Constants.bodyFont
        button.titleLabel?.accessibilityIdentifier = "AddItemModalTitle"
        button.backgroundColor = Constants.accentColor
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
        label.numberOfLines = 2
        label.textColor = Constants.primaryColor
        label.font = Constants.bodyFont 
        
        label.text = "Хм… Пока тут тихо.\nНажмите кнопку, чтобы начать."
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing =  Constants.smallSpacing
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
        updateEmptyState()
    }
    
    // MARK: - IB Actions
    @IBAction private func showAddItemModalButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        
        let modalViewController = AddShoppingItemViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        
        modalViewController.viewModel.onSendItem = { [weak self] newItemText in
            guard let self = self else { return }
            self.viewModel.addShoppingItem(title: newItemText)
            self.shoppingItemsTableView.reloadData()
            self.updateEmptyState()
        }
        
        present(modalViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, currentDayHeader, shoppingItemsTableView, showAddItemModalButton, emptyStateLabel, emptyStateImageView].forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func updateEmptyState() {
        let isEmpty = viewModel.isEmpty
        emptyStateImageView.isHidden = !isEmpty
        emptyStateLabel.isHidden = !isEmpty
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension ShoppingListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomHalfPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: UITableViewDataSource
extension ShoppingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingItemTableViewCell.reuseIdentifier, for: indexPath) as? ShoppingItemTableViewCell else { return UITableViewCell() }
        
        let shoppingItem = viewModel.shoppingItems[indexPath.row]
        print("Configuring cell for item: \(shoppingItem.title)")

        cell.configure(with: shoppingItem)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
