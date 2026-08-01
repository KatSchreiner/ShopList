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
    
    private var tapInstalled = false
    
    var onResult: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    }
    
    func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization(completion)
    }

    func ensureAudioEngineRunning(completion: ((Bool) -> Void)? = nil) {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            handleError(NSError(domain: "VoiceInputManager", code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Распознаватель речи недоступен"]),
                        completion)
            return
        }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default,
                                    options: [.defaultToSpeaker, .allowBluetoothHFP])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            handleError(error, completion)
            return
        }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        if !tapInstalled {
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }
            tapInstalled = true
        }
        
        if !audioEngine.isRunning {
            do {
                try audioEngine.prepare()
                try audioEngine.start()
            } catch {
                handleError(error, completion)
                return
            }
        }
        
        completion?(true)
    }
    
    func stopAudioEngine() {
        print("🔇 stopAudioEngine")
        if audioEngine.isRunning {
            audioEngine.inputNode.removeTap(onBus: 0)
            tapInstalled = false
        }
        audioEngine.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    func startNewRecognitionSession(completion: ((Bool) -> Void)? = nil) {
        print("🎙️ startNewRecognitionTask, audioEngine.isRunning = \(audioEngine.isRunning)")

        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            handleError(NSError(domain: "VoiceInputManager", code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Распознаватель речи недоступен"]),
                        completion)
            return
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false
        recognitionRequest = request
        
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.onError?(error)
                return
            }
            
            if let result = result {
                self.onResult?(result.bestTranscription.formattedString)
            }
        }
        
        completion?(true)
    }
    
    
    func stopRecognitionSession() {
        print("⏹️ stopRecognitionTask")
        recognitionTask?.cancel()
         recognitionTask = nil
         recognitionRequest?.endAudio()
         recognitionRequest = nil
    }
    
    func stopAll() {
        print("⏹️ stopAll")
        stopRecognitionSession()
        stopAudioEngine()
    }
    
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            switch AVAudioApplication.shared.recordPermission {
            case .granted: completion(true)
            case .denied: completion(false)
            case .undetermined: AVAudioApplication.requestRecordPermission { completion($0) }
            @unknown default:
                completion(false)
            }
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted: completion(true)
            case .denied: completion(false)
            case .undetermined: AVAudioSession.sharedInstance().requestRecordPermission { completion($0) }
            @unknown default:
                completion(false)
            }
        }
    }
    
    private func handleError(_ error: Error, _ completion: ((Bool) -> Void)?) {
        onError?(error)
        completion?(false)
    }
}
