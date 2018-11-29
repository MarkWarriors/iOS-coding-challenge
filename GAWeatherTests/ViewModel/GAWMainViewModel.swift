//
//  GAWMainViewModel.swift
//  GAWeatherTests
//
//  Created by Marco Guerrieri on 29/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest
@testable import GAWeather

class GAWMainViewModelTest: XCTestCase {
    
    var viewModel : GAWMainViewModel?
    
    override func setUp() {
        let environment = Environments.testEnv
        let apiHandler = ApiHandler.init(environment: environment)
        let speechRecognizer = GAWSpeechRecognizer.init()
        viewModel = GAWMainViewModel.init(apiHandler: apiHandler, speechRecognizer: speechRecognizer)
        
    }
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testViewModel() {
        // TODO TEST Implementing also a fake speech recognizer that provide fake transcript and see if the results are correct
    }
    
}
