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
    private var clearListButtonBottomConstraint: NSLayoutConstraint?

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
        label.textAlignment = .left
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
    
    private lazy var clearListButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "clean_list"), for: .normal)
        button.addTarget(self, action: #selector(clearListButtonTapped), for: .touchUpInside)
        button.titleLabel?.accessibilityIdentifier = "ClearListButtonTitle"
        button.accessibilityLabel = "Очистить список покупок"
        button.accessibilityHint = "Удаляет все товары из списка"
        return button
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
        imageView.accessibilityIdentifier = "EmptyStateImageView"
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
        label.accessibilityIdentifier = "EmptyStateLabel"
        return label
    }()
    
    private var insertionIndexPath: IndexPath?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateCurrentDayHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateEmptyState()
    }
    
    // MARK: - IB Actions
    @IBAction private func showAddItemModalButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        
        let modalViewController = AddShoppingItemViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        
        modalViewController.viewModel.onSendItem = { [weak self] newItemText in
            self?.handleNewItem(newItemText)
        }
        
        present(modalViewController, animated: true, completion: nil)
    }
    
    @IBAction private func clearListButtonTapped() {
        guard let visibleRows = shoppingItemsTableView.indexPathsForVisibleRows else {
            viewModel.clearList()
            shoppingItemsTableView.reloadData()
            updateEmptyState()
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            for indexPath in visibleRows {
                if let cell = self.shoppingItemsTableView.cellForRow(at: indexPath) {
                    cell.alpha = 0
                }
            }
        }, completion: { _ in
            self.viewModel.clearList()
            self.shoppingItemsTableView.reloadData()
            self.updateEmptyState()
        })
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, currentDayHeader, clearListButton, shoppingItemsTableView, showAddItemModalButton, emptyStateLabel, emptyStateImageView].forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        setupConstraint()
        
    }

    private func setupConstraint() {
        clearListButtonBottomConstraint = clearListButton.bottomAnchor.constraint(equalTo: shoppingItemsTableView.topAnchor, constant: 60)
        clearListButtonBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            currentDayHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            currentDayHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60),
        
            clearListButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            
            shoppingItemsTableView.topAnchor.constraint(equalTo: currentDayHeader.bottomAnchor, constant: 20),
            shoppingItemsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            shoppingItemsTableView.bottomAnchor.constraint(equalTo: showAddItemModalButton.topAnchor, constant: -20),
            shoppingItemsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            showAddItemModalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showAddItemModalButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            showAddItemModalButton.widthAnchor.constraint(equalToConstant: 200),
            showAddItemModalButton.heightAnchor.constraint(equalToConstant: 60),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 30),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func updateCurrentDayHeader() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, EE"
        dateFormatter.locale = Locale(identifier: "ru-RU")
        
        currentDayHeader.text = dateFormatter.string(from: Date())
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.isEmpty

        animateEmptyState(isEmpty: isEmpty)
        animateClearButton(isEmpty: isEmpty)
    }
    
    private func animateClearButton(isEmpty: Bool) {
        clearListButtonBottomConstraint?.constant = isEmpty ? 60 : 0
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
        ){
            self.view.layoutIfNeeded()
            self.clearListButton.alpha = isEmpty ? 0 : 1
        }
    }
    
    private func animateEmptyState(isEmpty: Bool) {
        let emptyStateViews = [
            emptyStateLabel,
            emptyStateImageView
        ]

        if isEmpty {
            emptyStateViews.forEach {
                $0.fadeIn(duration: 0.3)
            }
        } else {
            emptyStateViews.forEach {
                $0.fadeOut(duration: 0.3, hideAfterAnimation: true)
            }
        }
    }
    
    private func handleNewItem(_ title: String) {
        let indexPath = IndexPath(row: viewModel.shoppingItems.count, section: 0)
        
        insertionIndexPath = indexPath
        viewModel.addShoppingItem(title: title)
        
        shoppingItemsTableView.performBatchUpdates {
            shoppingItemsTableView.insertRows(at: [indexPath], with: .none)
        } completion: { [weak self] _ in
            guard let self = self,
                  let cell = self.shoppingItemsTableView.cellForRow(at: indexPath) as? ShoppingItemTableViewCell else {
                return
            }
            
            self.insertionIndexPath = nil
            self.updateEmptyState()
            cell.animateInsertion()
        }
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

        cell.configure(with: shoppingItem)
        cell.selectionStyle = .none
        
        if indexPath == insertionIndexPath {
            cell.prepareForInsertion()
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.shoppingItems[indexPath.row]
        viewModel.toggleItemChecked(id: item.id)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
