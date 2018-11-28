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
    
    fileprivate func weatherForCity(_ city: String) -> URL {
        return URL(string: environment.baseUrl + "weather?APPID=" + environment.apikey + "&q=" + city)!
    }
    
    public func getWeatherFor(city: String, callback: ((GAWWeatherResponse?, GAWError?)->())?){
        let uri = self.weatherForCity(city)
        self.sessionManager.request(uri, method: .get)
            .validate()
            .responseData { (response) in
                switch (response.result) {
                case .success:
                    var statusCode = 0
                    var model : GAWWeatherResponse?
                    if let unwrappedResponse = response.response {
                        statusCode = unwrappedResponse.statusCode
                        model = try? JSONDecoder.init().decode(GAWWeatherResponse.self, from: response.data!)
                    }
                    callback?(model, GAWError.checkErrorCode(statusCode))
                    break
                case .failure:
                    let statusCode = response.response?.statusCode ?? 0
                    callback?(nil, GAWError.checkErrorCode(statusCode))
                    break
                }
        }
    }
    
}
