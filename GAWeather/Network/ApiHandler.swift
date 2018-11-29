//
//  ApiHandler.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation
import Alamofire

class ApiHandler {
    
    private let environment: Environment
    private let sessionManager : SessionManager

    init(environment: Environment) {
        self.environment = environment
        self.sessionManager = SessionManager.init()
    }
    
    fileprivate func uriWeatherForCity(_ city: String) -> URL {
        let city = city
            .replacingOccurrences(of: " ", with: "+")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return URL(string: environment.baseUrl + "weather?APPID=" + environment.apikey + "&q=" + city)!
    }
    
    public func getWeatherFor(city: String, callback: ((GAWWeather?, GAWError?)->())?){
        let uri = self.uriWeatherForCity(city)
        print(uri)
        self.sessionManager.request(uri, method: .get)
            .validate()
            .responseData { (response) in
                switch (response.result) {
                case .success:
                    let model : GAWWeather? = try? JSONDecoder.init().decode(GAWWeather.self, from: response.data!)
                    
                    if model != nil {
                        callback?(model, nil)
                    }
                    else{
                        callback?(nil, GAWError(localizedDescription: GAWStrings.Errors.unknownError))
                    }
                    break
                case .failure:
                    // TODO: improve errors from status code
                    callback?(nil, GAWError(localizedDescription: GAWStrings.Errors.invalidRequest))
                    break
                }
        }
    }
    
}
