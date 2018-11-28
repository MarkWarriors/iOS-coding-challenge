//
//  ApiResponses.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation

// response from openweathermap
public class GAWWeatherResponse: Codable {
    var coord : GAWWeatherCoord?
    var weather : [GAWWeatherInfo]?
    var base : String?
    var main : GAWWeatherMain?
    var visibility : Int?
    var wind : GAWWeatherWind?
    var clouds : GAWWeatherClouds?
    var dt : Int?
    var sys : GAWWeatherSys?
    var id : Int?
    var name : String?
    var cod : Int?
    
    class GAWWeatherCoord : Codable {
        var lon : Double = 0
        var lat : Double = 0
    }
    
    class GAWWeatherInfo : Codable {
        var id : Int?
        var main : String?
        var description : String?
        var icon : String?
    }
    
    class GAWWeatherMain : Codable {
        var temp : Double?
        var pressure : Double?
        var humidity : Double?
        var temp_min : Double?
        var temp_max : Double?
    }
    
    class GAWWeatherWind : Codable {
        var speed : Int?
    }
    
    class GAWWeatherClouds : Codable {
        var all : Int?
    }

    class GAWWeatherSys : Codable {
        var type : Int?
        var id : Int?
        var message : Double?
        var country : String?
        var sunrise : Int?
        var sunset : Int?
    }
}
