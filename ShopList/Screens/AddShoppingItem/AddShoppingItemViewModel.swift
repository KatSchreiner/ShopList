//
//  AddItemViewModel.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit
import Combine
internal import AVFAudio

final class AddShoppingItemViewModel {
    let voiceInputManager = VoiceInputManager()
    
    @Published var itemText: String = ""
    @Published var isRecording: Bool = false
    @Published var voiceInputState: VoiceInputState = .idle
    @Published var hasDuplicateItem: Bool = false
    @Published var duplicateMessage: String?
    
    var onSendItem: ((String) -> Void)?
    var onCheckDuplicates: (([String]) -> Bool)?
    
    private var currentRecognizedText: String?
    
    init() {
        setupVoiceInputHandlers()
    }
    
    func toggleVoiceRecording() {
        if isRecording {
            stopVoiceRecording(userStopped: true)
        } else {
            startVoiceRecording()
        }
    }
    
    func sendItem() {
        let text = itemText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        do {
            let repository = ShoppingItemsRepository()
            hasDuplicateItem = try repository.exists(title: text)

        } catch {
            print("Ошибка проверки дубликата: \(error)")
            hasDuplicateItem = false
        }
        
        if hasDuplicateItem {
            duplicateMessage = "Такой товар уже есть в списке"
            return
        }
        
        onSendItem?(text)
        
        itemText = ""
        currentRecognizedText = nil
        hasDuplicateItem = false
        duplicateMessage = nil
        
        voiceInputManager.startNewRecognitionSession()
    }
    
    func cleanup() {
        voiceInputManager.stopAll()
    }
    
    func clearItemText() {
        itemText = ""
        currentRecognizedText = nil
        
        if isRecording {
            voiceInputManager.startNewRecognitionSession()
        }
    }
    
    private func setupVoiceInputHandlers() {
        voiceInputManager.onResult = { [weak self] text in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if self.isRecording {
                    self.currentRecognizedText = text
                    self.itemText = text
                }
            }
        }
        
        voiceInputManager.onError = { [weak self] error in
            guard let self = self else { return }
            print("❌ Ошибка распознавания: \\(error.localizedDescription)")
            DispatchQueue.main.async {
                self.voiceInputState = .stopped
            }
        }
    }
    
    func startVoiceRecording() {
        isRecording = true
        
        voiceInputManager.requestMicrophonePermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                do {
                    try self.voiceInputManager.prepareAudioSession()
                    try self.voiceInputManager.ensureTapInstalled()
                    try self.voiceInputManager.startAudioEngineIfNeeded()
                    
                    self.voiceInputManager.startNewRecognitionSession()
                } catch {
                    print("❌ Ошибка подготовки аудио: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.isRecording = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }
    }

    
    func stopVoiceRecording(userStopped: Bool) {
        isRecording = false
        voiceInputManager.stopRecognitionSession()
        
        if userStopped {
            voiceInputManager.stopAudioEngine()
        }
        
        if userStopped, let savedText = currentRecognizedText, !savedText.isEmpty {
            itemText = savedText
        }
    }
}
