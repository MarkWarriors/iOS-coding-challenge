//
//  ApiResponses.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import UIKit

// response from openweathermap
public class GAWWeather: Codable {
    var coord : GAWWeatherCoord?
    var weather : [GAWWeatherInfo]?
    var base : String?
    var main : GAWWeatherMain?
    var visibility : Double?
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
        var speed : Double?
        var deg : Double?
    }
    
    class GAWWeatherClouds : Codable {
        var all : Double?
    }

    class GAWWeatherSys : Codable {
        var type : Int?
        var id : Int?
        var message : Double?
        var country : String?
        var sunrise : Int?
        var sunset : Int?
    }
    
    public func getIconImage() -> UIImage? {
        var image : UIImage?
        if let icon = self.weather?[0].icon,
            let imageUri = URL(string: "https://openweathermap.org/img/w/\(icon).png") {
            let imageData : NSData? = try? NSData.init(contentsOf: imageUri, options: .mappedIfSafe)
            if let data = imageData as Data? {
                image = UIImage(data: data)
            }
        }
        return image
    }
    
    public func cityString() -> String {
        return self.name ?? GAWStrings.Commons.unknown + (self.sys?.country != nil ? "(\(self.sys!.country!))" : "")
    }
    
    public func weatherString() -> String {
        return (self.weather != nil && self.weather!.count > 0 && self.weather![0].main != nil) ? self.weather![0].main! : "-"
    }
    
    public func temperatureString() -> String {
        return self.main?.temp != nil ? "\((self.main!.temp! - 273.15).toStringWith(decimals: 1))°C" : "-"
    }
    
    public func humidityString() -> String {
        return self.main?.humidity != nil ? "\((self.main!.humidity!).toStringWith(decimals: 0))%" : "-"
    }
    
}
