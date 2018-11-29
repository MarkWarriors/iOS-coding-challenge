//
//  GAWeatherUITests.swift
//  GAWeatherUITests
//
//  Created by Marco Guerrieri on 29/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest

class GAWeatherUITests: XCTestCase {
    var app: XCUIApplication = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launchArguments.append("--uitesting")
        app.launch()
        
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    func testMain(){
        let mainViewIdentifier = "mainView"
        let weatherViewIdentifier = "weatherView"
        let loadingIndicatorIdentifier = "loadingIndicator"
        let transcriptionLblIdentifier = "transcriptionLbl"
        XCTAssertTrue(app.isDisplaying(mainViewIdentifier))
        XCTAssertFalse(app.isDisplaying(weatherViewIdentifier))
        XCTAssertFalse(app.isDisplaying(loadingIndicatorIdentifier))
        XCTAssertFalse(app.isDisplaying(transcriptionLblIdentifier))
        // TODO using a mock speech recognizer implements test on show/hide of weatherView, loadingIndicator, transcriptionLbl
    }
    
    
    
}

extension XCUIApplication {
    func isDisplaying(_ viewName: String) -> Bool {
        return otherElements[viewName].exists
    }
}

