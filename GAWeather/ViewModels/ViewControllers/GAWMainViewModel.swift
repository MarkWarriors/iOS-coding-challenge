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
    
    private static let weatherRegex = "weather (in|at|for|from) "
    private static let speechTimerSilenceTimeout = 1.5
    
    private let apiHandler = ApiHandler.init(environment: Environments.testEnv)
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
    
    private var privateOnLoading : Bool = false {
        didSet {
            self.onLoading?(privateOnLoading)
        }
    }
    
    public var onErrorOccurred : ((GAWError)->())?
    public var onLoading : ((Bool)->())?
    
    public func viewDidAppear() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                self.startRecording()
                break
            case .denied:
                self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.speechUnauthorized)
                break
            case .restricted:
                self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.speechUnavailable)
                break
            case .notDetermined:
                self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.speechUndetermined)
                break
            }
        }
    }
    
    
    fileprivate func startRecording() {
        if audioEngine.isRunning {
            self.privateErrorOccurred = GAWError(localizedDescription: GAWStrings.errorGeneric)
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
                    print("TRANSCR: " + transcription.formattedString)
                    self.privateOnLoading = true
                }
                self.speechSilenceTimer.invalidate()
                self.speechSilenceTimer = Timer.scheduledTimer(withTimeInterval: GAWMainViewModel.speechTimerSilenceTimeout, repeats: false, block: { (timer) in
                    let regex = try? NSRegularExpression(pattern: GAWMainViewModel.weatherRegex, options: [])
                    if let regex = regex, let transcription = result?.bestTranscription.formattedString.lowercased() {
                        let nsString = transcription as NSString
                        if let match = regex.firstMatch(in: transcription, options: [], range: NSMakeRange(0, nsString.length)) {
                            let city = nsString.substring(from: match.range(at: 0).location + match.range(at: 0).length)
                            
                            self.weatherForCity(city)
                        }
                    }

                    self.stopRecording()
                    self.startRecording()
                })
            }
        }
    }
    
    fileprivate func weatherForCity(_ city: String){
        print("search for \(city)")
        self.apiHandler.getWeatherFor(city: city, callback: { (weather, error) in
            print(weather)
        })
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
