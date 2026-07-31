//
//  VoiceInputManager.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 31.07.2026.
//

import UIKit
import Speech

final class VoiceInputManager {
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    var audioEngine = AVAudioEngine()
    
    var onResult: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    }
    
    func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status)
            }
        }
    }
    
    func startRecording(completion: ((Bool) -> Void)? = nil) {
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            onError?(NSError(domain: "VoiceInputManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Распознаватель речи недоступен"]))
            completion?(false)
            return
        }
        
        stopRecording()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetoothHFP]
            )
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            onError?(error)
            completion?(false)
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            onError?(NSError(domain: "VoiceInputManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать запрос распознавания"]))
            completion?(false)
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = false
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.onError?(error)
                self.stopRecording()
                completion?(false)
                return
            }
            
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.onResult?(text)
                
                if result.isFinal {
                    self.stopRecording()
                    completion?(true)
                }
            }
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        do {
            try audioEngine.prepare()
            try audioEngine.start()
        } catch {
            self.onError?(error)
            self.stopRecording()
            completion?(false)
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {}
    }
    
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .denied:
                DispatchQueue.main.async {
                    completion(false)
                }
            case .undetermined:
                AVAudioApplication.requestRecordPermission { granted in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            @unknown default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                DispatchQueue.main.async {
                    completion(true)
                }
            case .denied:
                DispatchQueue.main.async {
                    completion(false)
                }
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    DispatchQueue.main.async {
                        completion(granted)
                    }
                }
            @unknown default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
}
