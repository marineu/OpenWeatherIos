//
//  LocationListViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 12/09/2021.
//

import Foundation

public class LocationListViewModel: BaseViewModel {

    let appDataManager: AppDataManager
    let weatherApiManager: WeatherApiManager

    private(set) var reloadTableView: Bindable<()> = Bindable(())
    private(set) var cityListDidChange: Bindable<Bool> = Bindable(false)

    var cityWeatherForecasts: CityWeatherForecasts {
        return appDataManager.cityWeathers
    }

    init(appDataManager: AppDataManager, weatherApiManager: WeatherApiManager) {
        self.appDataManager = appDataManager
        self.weatherApiManager = weatherApiManager
        super.init()
    }

    public func loadData(for city: City, isChangedList: Bool) {
        isLoading.value = true

        weatherApiManager.oneCallCurrentWeather(
            latitude: city.latitude,
            longitude: city.longitude
        ) { [weak self] response, error in
            guard let self = self else { return }

            guard
                let response = response,
                error == nil
            else {
                return
            }

            var cityWeathers = self.appDataManager.cityWeathers
            let cityWeatherForecast = CityWeatherForecast(city: city, oneCallResponse: response)

            if let index = cityWeathers.firstIndex(where: { $0.city.identifier == city.identifier }) {
                cityWeathers[index] = cityWeatherForecast
            } else {
                cityWeathers.append(cityWeatherForecast)
            }

            self.appDataManager.setCityWeatherStoreServiceValue(cityWeathers)

            self.isLoading.value = false
            self.reloadTableView.value = ()
            self.cityListDidChange.value = isChangedList
        }
    }

    public func addCity(_ city: City) {
        var cityWeathers = self.appDataManager.cityWeathers
        let cityWeatherForecast = CityWeatherForecast(city: city, oneCallResponse: OneCallResponse())
        cityWeathers.append(cityWeatherForecast)

        appDataManager.setCityWeatherStoreServiceValue(cityWeathers)
    }

    public func deleteCity(at index: Int) {
        var cityWeathers = self.appDataManager.cityWeathers
        cityWeathers.remove(at: index)
        self.appDataManager.setCityWeatherStoreServiceValue(cityWeathers)

        cityListDidChange.value = true
    }

    public func moveCity(at sourceIndex: Int, to destinationIndex: Int) {
        var cityWeathers = self.appDataManager.cityWeathers
        cityWeathers.swapAt(sourceIndex, destinationIndex)
        self.appDataManager.setCityWeatherStoreServiceValue(cityWeathers)

        cityListDidChange.value = true
    }
}
