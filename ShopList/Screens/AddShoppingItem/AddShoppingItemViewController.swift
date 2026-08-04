//
//  AddItemViewController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//
import UIKit
import Speech
import Combine

final class AddShoppingItemViewController: UIViewController {
    // MARK: - Private Properties
    let viewModel = AddShoppingItemViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        textField.font = Constants.bodyFont
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.backgroundColor = Constants.backgroundColor
        textField.textAlignment = .center
        textField.clipsToBounds = true
        textField.accessibilityIdentifier = "ItemNameTextField"
        textField.inputView = UIView()
        textField.rightView = clearButton
        textField.rightViewMode = .always
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .slDarkBlue.withAlphaComponent(0.2)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(clearItemNameTextField), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что купить?"
        label.textAlignment = .center
        label.textColor = .slDarkBlue.withAlphaComponent(0.5)
        label.font = Constants.bodyFont
        return label
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
        setupBindings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addItemVoiceButton.stopPulse()
        viewModel.cleanup()
    }
    
    @objc private func addItemVoiceButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        viewModel.toggleVoiceRecording()
    }
    
    @objc private func sendItemButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        viewModel.sendItem()
    }
    
    @objc private func clearItemNameTextField() {
        viewModel.clearItemText()
        itemNameTextField.text = ""
        updatePlaceholderVisibility(isEmpty: true)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        [gradientBackground, itemNameTextField, buttonStackView, placeholderLabel].forEach { view in
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
            
            placeholderLabel.leadingAnchor.constraint(equalTo: itemNameTextField.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: itemNameTextField.trailingAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: itemNameTextField.centerYAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 85)
        ])
    }
    
    private func setupBindings() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: itemNameTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .assign(to: \.itemText, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$itemText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                if self.itemNameTextField.text != text {
                    self.itemNameTextField.text = text
                }
                let isEmpty = text
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty
                self.updatePlaceholderVisibility(isEmpty: isEmpty)
            }
            .store(in: &cancellables)
        
        viewModel.$isRecording
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                self?.updateVoiceButtonAppearance(isRecording: isRecording)
            }
            .store(in: &cancellables)
    }
    
    private func updateVoiceButtonAppearance(isRecording: Bool) {
        if isRecording {
            addItemVoiceButton.startPulse(
                scale: 1.15,
                duration: 0.6
            )
            voiceLabel.text = "Остановить"
            voiceLabel.textColor = UIColor.slYellow
        } else {
            addItemVoiceButton.stopPulse()
            voiceLabel.text = "Зачитать"
            voiceLabel.textColor = .white
        }
    }
    
    private func updatePlaceholderVisibility(isEmpty: Bool) {
        if isEmpty {
            placeholderLabel.fadeIn(duration: 0.2)
        } else {
            placeholderLabel.fadeOut(duration: 0.2)
        }
    }
}
