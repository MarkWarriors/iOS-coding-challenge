//
//  GAWError.swift
//  GAWeather
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import Foundation


class GAWError: NSError {
    init(domain: String = "mg.weather", code: Int = 0, localizedDescription: String) {
        super.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


