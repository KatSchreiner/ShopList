//
//  AddItemViewController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//
import UIKit

final class AddShoppingItemViewController: UIViewController {
    // MARK: - Private Properties
    private lazy var gradientBackground: GradientBackgroundView = {
        let backgroundView = GradientBackgroundView(
            colors: [UIColor.slBlue.cgColor, UIColor.slViolet.cgColor],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 1.0)
        )
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        return backgroundView
    }()
    
    private lazy var itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Что купить?"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var addItemVoiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .slViolet
        button.setImage(UIImage(named: "voice_button"), for: .normal)
        button.addTarget(self, action: #selector(addItemVoiceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendItemButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "send_button"), for: .normal)
        button.addTarget(self, action: #selector(sendItemButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func addItemVoiceButtonTapped() {

    }
    
    @objc private func sendItemButtonTapped() {
        
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, itemNameTextField, addItemVoiceButton, sendItemButton].forEach { view in
            self.view.addSubview(view)
        }

        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            itemNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            itemNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            itemNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 70),
            
            addItemVoiceButton.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 50),
            addItemVoiceButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            
            sendItemButton.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 50),
            sendItemButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
    }
}
