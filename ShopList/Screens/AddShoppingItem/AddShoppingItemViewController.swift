//
//  AddItemViewController.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//
import UIKit
import Speech

final class AddShoppingItemViewController: UIViewController {
    // MARK: - Private Properties
    private let voiceInputManager = VoiceInputManager()
    private var isRecording = false
    private var isUserStoppedRecording = false
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        voiceInputManager.stopRecording()
    }
    
    deinit {
        voiceInputManager.stopRecording()
        voiceInputManager.audioEngine.stop()
    }
    
    @objc private func addItemVoiceButtonTapped() {
        UIImpactFeedbackGenerator(style: Constants.feedbackStyle).impactOccurred()
        //addItemVoiceButton.scaleDownAnimation()
        
        if isRecording {
            stopVoiceRecording()
            return
        }
        
        startVoiceRecording()
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
        setupVoiceInputHandlers()
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
    
    private func setupVoiceInputHandlers() {
        voiceInputManager.onResult = { [weak self] text in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.isRecording {
                    self.itemNameTextField.text = text
                }
            }
        }
        
        voiceInputManager.onError = { [weak self] error in
            guard let self = self else { return }
            print("❌ Ошибка распознавания: \\(error.localizedDescription)")
            DispatchQueue.main.async {
                self.stopVoiceRecording(userStopped: false)
            }
        }
    }
    
    private func startVoiceRecording() {
        isRecording = true
        updateVoiceButtonAppearance(isRecording: true)

        voiceInputManager.requestMicrophonePermission { [weak self] granted in
            guard let self = self else { return }

            if granted {
                self.voiceInputManager.startRecording { [weak self] success in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.stopVoiceRecording()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.stopVoiceRecording()
                }
            }
        }
    }
    
    private func stopVoiceRecording(userStopped: Bool = false) {
        let currentText = itemNameTextField.text
        
        isRecording = false
        isUserStoppedRecording = userStopped
        voiceInputManager.stopRecording()
        updateVoiceButtonAppearance(isRecording: false)

        if userStopped, let savedText = currentText, !savedText.isEmpty {
            itemNameTextField.text = savedText
        }
    }
    
    private func updateVoiceButtonAppearance(isRecording: Bool) {
        addItemVoiceButton.layer.removeAllAnimations()
        addItemVoiceButton.transform = .identity
        
        if isRecording {
            voiceLabel.text = "Остановить"
            voiceLabel.textColor = UIColor.slYellow
            
            DispatchQueue.main.async {
                self.addItemVoiceButton.backgroundColor = UIColor.red.withAlphaComponent(0.3)
                self.addItemVoiceButton.layer.cornerRadius = self.addItemVoiceButton.bounds.height / 2
                self.addItemVoiceButton.clipsToBounds = true
                
                UIView.animate(
                    withDuration: 0.8,
                    delay: 0,
                    options: [.autoreverse, .repeat, .allowUserInteraction],
                    animations: {
                        self.addItemVoiceButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    }
                )
            }
        } else {
            voiceLabel.text = "Зачитать"
            voiceLabel.textColor = .white
            
            addItemVoiceButton.backgroundColor = .clear
            addItemVoiceButton.layer.cornerRadius = 0
            addItemVoiceButton.clipsToBounds = false
        }
    }
}
