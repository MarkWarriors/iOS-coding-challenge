//
//  GAWDevicePermission.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 29/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import Speech

public class GAWDevicePermission {
    
    // TODO: make a function that giving multiple auth request, provide to chain the auth request

    public static func requestMicrophoneUsage(callback: ((Bool, String?)->())?){
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                callback?(true, nil)
                break
            case .denied:
                callback?(false, GAWStrings.Errors.speechUnauthorized)
                break
            case .restricted:
                callback?(false, GAWStrings.Errors.speechUnavailable)
                break
            case .notDetermined:
                callback?(false, GAWStrings.Errors.speechUndetermined)
                break
            }
        }
    }
    
    public static func requestSpeechRecognizerUsage(callback: ((Bool, String?)->())?){
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                callback?(true, nil)
            }
            else {
                callback?(false, GAWStrings.Errors.microphoneUnauthorized)
            }
        }
    }
    
}
