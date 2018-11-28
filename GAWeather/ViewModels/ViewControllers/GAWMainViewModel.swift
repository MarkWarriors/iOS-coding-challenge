//
//  GAWMainViewModel.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit
import Speech

class GAWMainViewModel: ViewModel {
    
    private static let speechTimerSilenceTimeout = 2.0
    private var speechSilenceTimer = Timer()
    private let audioQueue = DispatchQueue.init(label: "ga.weather.audioqueue", qos: DispatchQoS.userInteractive, attributes: .concurrent)
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer.init(locale: Locale.current)
    private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    private var privateErrorOccurred : GAWError? {
        didSet{
            if let error = privateErrorOccurred {
                self.onErrorOccurred?(error)
            }
        }
    }
    public var onErrorOccurred : ((GAWError)->())?
    
    public func viewDidAppear() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                self.startRecording()
                break
            case .denied:
                self.privateErrorOccurred = GAWError.with(localizedDescription: GAWStrings.speechUnauthorized)
                break
            case .restricted:
                self.privateErrorOccurred = GAWError.with(localizedDescription: GAWStrings.speechUnavailable)
                break
            case .notDetermined:
                self.privateErrorOccurred = GAWError.with(localizedDescription: GAWStrings.speechUndetermined)
                break
            }
        }
    }
    
    
    fileprivate func startRecording() {
        if audioEngine.isRunning {
            self.privateErrorOccurred = GAWError.with(localizedDescription: GAWStrings.errorGeneric)
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
                self.privateErrorOccurred = GAWError.with(localizedDescription: error.localizedDescription)
                return
            }
            self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.recognitionRequest) { (result, error) in
                if let transcription = result?.bestTranscription {
                    print(transcription.formattedString)
                }
                self.speechSilenceTimer.invalidate()
                self.speechSilenceTimer = Timer.scheduledTimer(withTimeInterval: GAWMainViewModel.speechTimerSilenceTimeout, repeats: false, block: { (timer) in
                    self.stopRecording()
                    self.startRecording()
                })
            }
        }
    }
    
    fileprivate func stopRecording() {
        audioQueue.sync {
            self.audioEngine.stop()
            self.recognitionRequest.endAudio()
            self.recognitionTask?.cancel()
            self.audioEngine.inputNode.removeTap(onBus: 0)
        }
    }
}
