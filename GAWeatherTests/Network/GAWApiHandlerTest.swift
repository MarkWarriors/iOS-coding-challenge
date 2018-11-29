//
//  GAWApiHandlerTest.swift
//  GAWApiHandlerTest
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest
@testable import GAWeather

class GAWApiHandlerTest: XCTestCase {
    
    var apiHandler : ApiHandler?
    
    override func setUp() {
        apiHandler = ApiHandler.init(environment: Environments.testEnv)
    }
    
    override func tearDown() {
        apiHandler = nil
    }
    
    func testApiHandler() {
        let expectation = self.expectation(description: "fetchDataCompleted")
        apiHandler?.getWeatherFor(city: "Berlin") { (weather, error) in
            if weather != nil {
                expectation.fulfill()
            }
            else if let error = error {
                print("ERROR\n" + error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
}
