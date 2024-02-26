//
//  LocationSearchResultsViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/09/2021.
//

import Foundation

public class LocationSearchResultsViewModel: BaseViewModel {

    let appDataManager: AppDataManager
    private let searchCityManager = SearchCityManager()

    private(set) var cities: Cities = [] {
        didSet {
            reloadTableView.value = ()
        }
    }

    private(set) var reloadTableView: Bindable<()> = Bindable(())

    init(appDataManager: AppDataManager) {
        self.appDataManager = appDataManager
        super.init()

        searchCityManager.maxResultCount = 50
        searchCityManager.setAllCities(appDataManager.cities)
    }

    public func searchLocation(by text: String?) {
        guard let text = text, text.isEmpty == false else {
            cities.removeAll()
            return
        }

        searchCityManager.searchCities(byCityName: text)
        searchCityManager.searchResultBlock = { [weak self] cities in
            guard let self = self else {
                return
            }

            self.cities = cities
        }
    }
}
