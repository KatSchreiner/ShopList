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
    @Published var voiceInputState: VoiceRecordingState = .idle
    
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
        print("Отправка: \\(itemText)")
    }
    
    func cleanup() {
        voiceInputManager.stopRecording()
        voiceInputManager.audioEngine.stop()
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
                self.voiceInputState = .error(error.localizedDescription)
                self.stopVoiceRecording(userStopped: false)
            }
        }
    }
    
    func startVoiceRecording() {
        isRecording = true
        
        voiceInputManager.requestMicrophonePermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                self.voiceInputManager.startRecording { [weak self] success in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.stopVoiceRecording(userStopped: false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.stopVoiceRecording(userStopped: false)
                }
            }
        }
    }
    
    func stopVoiceRecording(userStopped: Bool) {
        isRecording = false
        voiceInputManager.stopRecording()
        
        if userStopped, let savedText = currentRecognizedText, !savedText.isEmpty {
            itemText = savedText
        }
    }
}
