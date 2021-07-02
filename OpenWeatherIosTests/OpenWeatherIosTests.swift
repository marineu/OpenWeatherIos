//
//  OpenWeatherIosTests.swift
//  OpenWeatherIosTests
//
//  Created by Marin Ipati on 25/04/2021.
//

import XCTest
@testable import OpenWeatherIos

class OpenWeatherIosTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAllCities() throws {
        let expectation = XCTestExpectation(description: "Download the list of cities")

        WeatherApiManager.shared.getAllCities { cities, _ in
            XCTAssertFalse(cities.isEmpty, "No cities loaded.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func testOneCallCurrentWeather() throws {
        let expectation = XCTestExpectation(description: "Load city's one call current weather")

        WeatherApiManager.shared.oneCallCurrentWeather(latitude: 46.35, longitude: 9.18) { oneCallResponse, _ in
            XCTAssertNotNil(oneCallResponse, "No city's one call current weather loaded.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
