//
//  GAWMainViewModel.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

class GAWMainViewModel {
    
    private let apiHandler : ApiHandler
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
    
    
    init(apiHandler: ApiHandler,
         speechRecognizer: GAWSpeechRecognizer) {
        self.apiHandler = apiHandler
        self.speechRecognizer = speechRecognizer
        
        self.speechRecognizer.onLoading = { loading in
            self.privateOnLoading = loading
        }
        self.speechRecognizer.onTranscriptionChanged = { text in
            self.privateTranscriptionChange = text
        }
        
        self.speechRecognizer.onErrorOccurred = { error in
            self.privateErrorOccurred = error
        }
        
        self.speechRecognizer.onCommandReceived = { command in
            let regex = try? NSRegularExpression(pattern: GAWMainViewModel.weatherRegex, options: [])
            if let regex = regex,
                let match = regex.firstMatch(in: command as String, options: [], range: NSMakeRange(0, command.length)) {
                let city = command.substring(from: match.range(at: 0).location + match.range(at: 0).length)
                // TODO: call a service to see if it can find a city in a different language and translate into the locale (en) needed by openweather
                self.apiHandler.getWeatherFor(city: city, callback: { (weather, error) in
                    if let weather = weather {
                        self.updateUI(weather: weather)
                    }
                    else {
                        self.privateWeatherInfo = nil
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
