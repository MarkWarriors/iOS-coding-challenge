//
//  GAWMainViewModel.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class GAWMainViewModel {
    
    private let apiHandler : GAWWeatherApiHandler
    private let commandParser : GAWCommandParser
    private let speechRecognizer : GAWSpeechRecognizer
    
    private static let weatherRegex = "weather (in|at|for|from) "

    
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
    
    private var privateWeatherInfo : WeatherInfo? {
        didSet {
            self.onWeatherChange?(privateWeatherInfo)
        }
    }
    
    private var privateTranscriptionChange : String? {
        didSet {
            self.onTranscriptionChange?(privateTranscriptionChange)
        }
    }
    
    public var onErrorOccurred : ((GAWError)->())?
    public var onLoading : ((Bool)->())?
    public var onWeatherChange : ((WeatherInfo?)->())?
    public var onTranscriptionChange : ((String?)->())?
    
    
    init(apiHandler: GAWWeatherApiHandler,
         speechRecognizer: GAWSpeechRecognizer,
         commandParser: GAWCommandParser) {
        self.apiHandler = apiHandler
        self.speechRecognizer = speechRecognizer
        self.commandParser = commandParser
        
        self.speechRecognizer.onLoading = { [weak self] loading in
            self?.privateOnLoading = loading
        }
        self.speechRecognizer.onTranscriptionChanged = { [weak self] text in
            self?.privateTranscriptionChange = text
        }
        
        self.speechRecognizer.onErrorOccurred = { [weak self] error in
            self?.privateErrorOccurred = error
        }
        
        self.speechRecognizer.onCommandReceived = { [weak self] command in
            guard let self = self else { return }
            let operation = self.commandParser.parse(command) as? GAWWeatherOperation
            if let city = operation?.city {
                self.apiHandler.getWeatherFor(city: city, callback: { (weather, error) in
                    if let weather = weather {
                        self.updateUI(weather: weather)
                    }
                    else {
                        self.privateWeatherInfo = nil
                    }
                    
                    if let error = error {
                        self.privateErrorOccurred = error
                    }
                    
                    self.speechRecognizer.startListening()
                })
            }
            else {
                self.speechRecognizer.startListening()
            }
        }
    }
    
    public func viewDidAppear() {
        self.speechRecognizer.startListening()
        self.onTranscriptionChange?("")
    }
    
    fileprivate func updateUI(weather: GAWWeather) {
        let weatherInfo = WeatherInfo(
                            weatherImage: weather.getIconImage(),
                            city: weather.cityString(),
                            weather: GAWStrings.Weather.weather + ": " + weather.weatherString(),
                            temperature: GAWStrings.Weather.temperature + ": " + weather.temperatureString(),
                            humidity: GAWStrings.Weather.humidity + ": " + weather.humidityString())
        self.privateWeatherInfo = weatherInfo
    }
    
}
