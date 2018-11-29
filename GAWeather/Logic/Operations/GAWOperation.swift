//
//  GAWOperation.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 29/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//


import Foundation

public enum GAWCommandType : Int {
    case unknown
    case weather
}

public protocol GAWOperation {
    static var regex : String {get}
    var commandType : GAWCommandType {get}
    var commandText : NSString {get}
}

public class GAWWeatherOperation : GAWOperation {
    public static var regex: String = "weather (in|at|for|from) "
    public var commandType: GAWCommandType
    public var commandText: NSString
    public var city : String?
    
    init(commandText: NSString) {
        self.commandText = commandText
        let regex = try? NSRegularExpression(pattern: GAWWeatherOperation.regex, options: [])
        if let regex = regex,
            let match = regex.firstMatch(in: commandText as String, options: [], range: NSMakeRange(0, commandText.length)) {
            let city = commandText.substring(from: match.range(at: 0).location + match.range(at: 0).length)
            // TODO: call a service to see if it can find a city in a different language and translate into the locale (en) needed by openweather
            self.commandType = .weather
            self.city = city
        }
        else {
            self.commandType = .unknown
        }
    }
}
