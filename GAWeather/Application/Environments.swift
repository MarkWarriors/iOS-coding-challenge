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
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}

class Environments {
    public static let testEnvironment = Environment(baseUrl: "https://")
    public static let productionEnv = Environment(baseUrl: "https://")
}


