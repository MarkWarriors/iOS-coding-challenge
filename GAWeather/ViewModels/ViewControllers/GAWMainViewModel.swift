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

    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer.init(locale: Locale.current)
    private let request = SFSpeechAudioBufferRecognitionRequest()
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
    
    func viewDidAppear() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
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
    
}
