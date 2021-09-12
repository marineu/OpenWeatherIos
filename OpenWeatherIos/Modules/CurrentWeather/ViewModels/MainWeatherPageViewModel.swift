//
//  MainWeatherPageViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/08/2021.
//

import Foundation

public class MainWeatherPageViewModel: BaseViewModel {

    let appDataManager: AppDataManager

    var cityWeatherForecasts: CityWeatherForecasts {
        return appDataManager.cityWeatherStoreService.value ?? []
    }

    init(appDataManager: AppDataManager) {
        self.appDataManager = appDataManager
        super.init()
    }
}
