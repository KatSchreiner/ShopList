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
            startPoint: Constants.directionOfGradient.start,
            endPoint: Constants.directionOfGradient.end
        )
        return backgroundView
    }()
    
    private lazy var itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Что купить?"
        textField.font = Constants.bodyFont
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = Constants.backgroundColor
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.accessibilityIdentifier = "ItemNameTextField"
        return textField
    }()
    
    private lazy var addItemVoiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "voice_button"), for: .normal)
        button.addTarget(self, action: #selector(addItemVoiceButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "AddItemVoiceButton"
        button.accessibilityLabel = "Зачитать новую покупку голосом"
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private lazy var voiceLabel: UILabel = {
        let label = UILabel()
        label.text = "Зачитать"
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.captionFont
        return label
    }()
    
    private lazy var sendItemButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "send_button"), for: .normal)
        button.addTarget(self, action: #selector(sendItemButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "SendItemButton"
        button.accessibilityLabel = "Отправить покупку в список"
        button.contentMode = .scaleAspectFit
        button.adjustsImageWhenHighlighted = false
        return button
    }()
    
    private lazy var sendLabel: UILabel = {
        let label = UILabel()
        label.text = "Отправить"
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.captionFont
        return label
    }()
    
    private lazy var voiceButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addItemVoiceButton, voiceLabel])
        stackView.axis = .vertical
        stackView.spacing = Constants.smallSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var sendButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sendItemButton, sendLabel])
        stackView.axis = .vertical
        stackView.spacing = Constants.smallSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [voiceButtonStackView, sendButtonStackView])
        stackView.axis = .horizontal
        stackView.spacing = Constants.defaultSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func addItemVoiceButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        addItemVoiceButton.scaleDownAnimation()
    }
    
    @objc private func sendItemButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        sendItemButton.scaleDownAnimation()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, itemNameTextField, buttonStackView].forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            gradientBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gradientBackground.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            itemNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            itemNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            itemNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            itemNameTextField.heightAnchor.constraint(equalToConstant: 70),
            
            buttonStackView.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 85)

        ])
    }
}
