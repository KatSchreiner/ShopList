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
    private var state: VoiceInputState = .idle
    
    var onResult: ((String) -> Void)?
    var onError: ((VoiceInputError) -> Void)?
    
    init(
        speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU")),
        audioEngine: AVAudioEngine = AVAudioEngine()
    ) {
        self.speechRecognizer = speechRecognizer
        self.audioEngine = audioEngine
    }
    
    func requestAuthorization(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization(completion)
    }
    
    func prepareAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothHFP])
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    func ensureTapInstalled() throws {
        guard !tapInstalled else { return }
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { [weak self] buffer, _ in
            guard let self = self else { return }
            self.recognitionRequest?.append(buffer)
        })
        
        self.tapInstalled = true
    }
    
    func startAudioEngineIfNeeded() throws {
        if !audioEngine.isRunning {
            try audioEngine.prepare()
            try audioEngine.start()
        }
    }
    
    func startNewRecognitionSession() {
        state = .recording
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            onError?(.recognizerUnavailable)
            state = .idle
            return
        }
        
        do {
            try prepareAudioSession()
            try ensureTapInstalled()
            try startAudioEngineIfNeeded()
        } catch {
            onError?(.audioSessionSetupFailed(error))
            state = .idle
            return
        }
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false
        recognitionRequest = request
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.onError?(.taskCancelled) // или более точная ошибка
                return
            }
            
            if let result = result {
                self.onResult?(result.bestTranscription.formattedString)
            }
        }
    }
    
    func stopRecognitionSession() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        state = .stopped
    }
    
    func stopAudioEngine() {
        if audioEngine.isRunning {
            audioEngine.inputNode.removeTap(onBus: 0)
            tapInstalled = false
            audioEngine.stop()
        }
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        state = .idle
    }
    
    func stopAll() {
        stopRecognitionSession()
        stopAudioEngine()
    }
    
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        MicrophonePermissionService.request(completion: completion)
    }
}
