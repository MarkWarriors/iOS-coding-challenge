//
//  Environments.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

class Environment {
    let baseUrl : String
    let apikey : String
    
    init(baseUrl: String, apikey: String) {
        self.baseUrl = baseUrl
        self.apikey = apikey
    }
}

class Environments {
    public static let testEnv = Environment(baseUrl: "https://api.openweathermap.org/data/2.5/", apikey: "630c7e08af5da1d3e1ec8468224e1356")
    public static let productionEnv = Environment(baseUrl: "https://api.openweathermap.org/data/2.5/", apikey: "630c7e08af5da1d3e1ec8468224e1356")
}


