//
//  GAWError.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation


class GAWError: Error {

    static func with(domain: String = "mg.weather", code: Int = 0, localizedDescription: String) -> GAWError {
        return NSError(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription]) as! GAWError
    }
    
}


