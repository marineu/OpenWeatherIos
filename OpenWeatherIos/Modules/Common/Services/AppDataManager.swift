//
//  AppDataManager.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 10/07/2021.
//

import Foundation

public class AppDataManager: NSObject {

    static let shared = AppDataManager()

    private(set) var cityStoreService: ValueStoreService<Cities>
    private(set) var settingsStoreService: ValueStoreService<Settings>
    private(set) var cityWeatherStoreService: ValueStoreService<CityWeatherForecasts>

    public var cities: Cities {
        return cityStoreService.value ?? []
    }

    public var settings: Settings {
        return settingsStoreService.value ?? Settings()
    }

    public var cityWeathers: CityWeatherForecasts {
        return cityWeatherStoreService.value ?? []
    }

    private override init() {
        cityStoreService = ValueStoreService(fileName: Constants.citiesDataFileName)
        settingsStoreService = ValueStoreService(fileName: Constants.settingsDataFileName)
        cityWeatherStoreService = ValueStoreService(fileName: Constants.cityWeatherDataFileName)
        super.init()
    }

    public func setCityStoreServiceValue(_ cities: Cities) {
        cityStoreService.value = cities
    }

    public func setSettingsStoreServiceValue(_ settings: Settings) {
        settingsStoreService.value = settings
    }

    public func setCityWeatherStoreServiceValue(_ cityWeathers: CityWeatherForecasts) {
        cityWeatherStoreService.value = cityWeathers
    }

    public func synchronize() {
        cityStoreService.synchronize()
        settingsStoreService.synchronize()
        cityWeatherStoreService.synchronize()
    }
}
