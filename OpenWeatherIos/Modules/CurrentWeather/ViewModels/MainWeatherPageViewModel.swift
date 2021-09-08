//
//  MainWeatherPageViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/08/2021.
//

import Foundation

public class MainWeatherPageViewModel: BaseViewModel {

    let cityWeatherStoreService: ValueStoreService<CityWeatherForecasts>

    var cityWeatherForecasts: CityWeatherForecasts {
        return cityWeatherStoreService.value ?? []
    }

    init(cityWeatherStoreService: ValueStoreService<CityWeatherForecasts>) {
        self.cityWeatherStoreService = cityWeatherStoreService
        super.init()
    }
}
