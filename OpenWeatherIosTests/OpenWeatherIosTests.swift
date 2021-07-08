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

        wait(for: [expectation], timeout: 10.0)
    }

    func testOneCallCurrentWeather() throws {
        let expectation = XCTestExpectation(description: "Load city's one call current weather")

        WeatherApiManager.shared.oneCallCurrentWeather(latitude: 46.35, longitude: 9.18) { oneCallResponse, _ in
            XCTAssertNotNil(oneCallResponse, "No city's one call current weather loaded.")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testSearchText() throws {
        let stringUtils = StringUtils()

        let firstResult = stringUtils.searchText("nt we", in: "Current weather")
        let secondResult = stringUtils.searchText("at en", in: "Current weather")
        let thirdResult = stringUtils.searchText("current th er", in: "Current weather")
        let forthResult = stringUtils.searchText("informatiei", in: "Tehnologia informației")
        let fithResult = stringUtils.searchText("", in: "Current weather")

        XCTAssertTrue(firstResult)
        XCTAssertFalse(secondResult)
        XCTAssertTrue(thirdResult)
        XCTAssertTrue(forthResult)
        XCTAssertFalse(fithResult)
    }

    func testRangesOfFoundText() throws {
        let stringUtils = StringUtils()

        let firstRanges = stringUtils.rangesOfFoundText("nt we", in: "Current weather")
        let secondRanges = stringUtils.rangesOfFoundText("at en", in: "Current weather")
        let thirdRanges = stringUtils.rangesOfFoundText("current th er", in: "Current weather")
        let forthRanges = stringUtils.rangesOfFoundText("informatiei", in: "Tehnologia informației")
        let fithRanges = stringUtils.rangesOfFoundText("", in: "Current weather")

        XCTAssertEqual(firstRanges.count, 2)
        XCTAssertEqual(secondRanges.count, 0)
        XCTAssertEqual(thirdRanges.count, 3)
        XCTAssertEqual(forthRanges.count, 1)
        XCTAssertEqual(fithRanges.count, 0)

        let firstResult = getFoundText(from: firstRanges, in: "Current weather")
        let secondResult = getFoundText(from: secondRanges, in: "Current weather")
        let thirdResult = getFoundText(from: thirdRanges, in: "Current weather")
        let forthResult = getFoundText(from: forthRanges, in: "Tehnologia informației")
        let fithResult = getFoundText(from: fithRanges, in: "Current weather")

        XCTAssertEqual(firstResult, "nt we")
        XCTAssertEqual(secondResult, "")
        XCTAssertEqual(thirdResult, "Current th er")
        XCTAssertEqual(forthResult, "informației")
        XCTAssertEqual(fithResult, "")
    }

    func getFoundText(from ranges: [Range<String.Index>], in string: String) -> String {
        return ranges.map { String(string[$0]) }.joined(separator: " ")
    }
}
