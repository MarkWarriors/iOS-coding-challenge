//
//  GAWSpeechRecognizer.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 29/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import Speech

public class GAWSpeechRecognizer {
    
    //TODO implements locale
    
    private static let speechTimerSilenceTimeout = 1.5
    private var speechSilenceTimer = Timer()
    private let audioQueue = DispatchQueue.init(label: "ga.weather.audioqueue", qos: DispatchQoS.userInteractive, attributes: .concurrent)
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer.init(locale: Locale.current)
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    
    private var privateErrorOccurred : GAWError? {
        didSet {
            if let error = privateErrorOccurred {
                self.onErrorOccurred?(error)
            }
        }
    }
    
    private var privateTranscription : String = "" {
        didSet {
            self.onTranscriptionChanged?(privateTranscription)
        }
    }
    
    private var privateCommandReceived : NSString = "" {
        didSet {
            self.onCommandReceived?(privateCommandReceived)
        }
    }
    
    private var privateLoading : Bool = false {
        didSet {
            self.onLoading?(privateLoading)
        }
    }
    
    public var onErrorOccurred : ((GAWError)->())?
    public var onTranscriptionChanged : ((String)->())?
    public var onCommandReceived : ((NSString)->())?
    public var onLoading : ((Bool)->())?
    
    
    public func startListening(){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                self.privateStartListening()
                break
            case .denied:
                self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.Errors.speechUnauthorized)
                break
            case .restricted:
                self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.Errors.speechUnavailable)
                break
            case .notDetermined:
                self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.Errors.speechUndetermined)
                break
            }
        }
    }
    
    fileprivate func privateStartListening() {
        self.privateTranscription = ""
        self.privateLoading = false
        
        if audioEngine.isRunning {
            self.stopListening()
            return
        }
        mostRecentlyProcessedSegmentDuration = 0
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        audioQueue.sync {
            let node = self.audioEngine.inputNode
            let recordingFormat = node.outputFormat(forBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024,
                            format: recordingFormat) { [unowned self]
                                (buffer, _) in
                                self.recognitionRequest.append(buffer)
            }
            self.audioEngine.prepare()
            do {
                try self.audioEngine.start()
            }
            catch let error {
                self.privateErrorOccurred = GAWError(localizedDescription: error.localizedDescription)
                return
            }
            
            self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.recognitionRequest) { (result, error) in
                if let transcription = result?.bestTranscription {
                    self.privateTranscription = transcription.formattedString
                    self.privateLoading = true
                }
                self.speechSilenceTimer.invalidate()
                self.speechSilenceTimer = Timer.scheduledTimer(withTimeInterval: GAWSpeechRecognizer.speechTimerSilenceTimeout, repeats: false, block: { (timer) in
                    self.stopListening()
                    if let command = result?.bestTranscription.formattedString.lowercased() {
                        self.privateCommandReceived = command as NSString
                    }
                    else {
                        self.startListening()
                    }
                })
            }
        }
    }
    
    public func stopListening() {
        audioQueue.sync {
            self.audioEngine.stop()
            self.recognitionRequest.endAudio()
            self.recognitionTask?.cancel()
            self.audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
}
