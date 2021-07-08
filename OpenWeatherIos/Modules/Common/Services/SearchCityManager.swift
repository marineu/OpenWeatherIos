//
//  SearchCityManager.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 02/07/2021.
//

import Foundation

public class SearchCityManager: NSObject {

    private var cities: Cities = []

    private var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1

        return operationQueue
    }()

    public var searchResultBlock: ((Cities) -> Void)?

    public func setAllCities(_ cities: Cities) {
        self.cities = cities
    }

    public func searchCities(byCityName cityName: String) {
        let stringUtils = StringUtils()

        let operation = BlockOperation { [weak self] in
            guard let self = self else { return }
            let filteredCities = self.cities.filter { stringUtils.searchText(cityName, in: $0.name) }

            self.searchResultBlock?(filteredCities)
        }
        operationQueue.addOperation(operation)
    }
}
