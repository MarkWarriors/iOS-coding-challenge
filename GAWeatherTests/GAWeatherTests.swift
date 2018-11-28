//
//  GAWeatherTests.swift
//  GAWeatherTests
//
//  Created by Marco Guerrieri on 28/11/18.
//  Copyright © 2018 Marco Guerrieri. All rights reserved.
//

import XCTest
@testable import GAWeather

class GAWeatherTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testExample() {
        let expectation = self.expectation(description: "fetchDataCompleted")
        let api = ApiHandler.init(environment: Environments.testEnvironment)
        api.getWeatherFor(city: "Ivrea") { (response) in
            print(response)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }


}
