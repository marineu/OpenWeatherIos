//
//  NoItemsViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import Foundation

public class NoItemsViewModel: BaseViewModel {

    let appDataManager: AppDataManager
    let weatherApiManager: WeatherApiManager

    let locationManager = LocationManager()

    private(set) var reloadData: Bindable<Bool> = Bindable(false)

    init(appDataManager: AppDataManager, weatherApiManager: WeatherApiManager) {
        self.appDataManager = appDataManager
        self.weatherApiManager = weatherApiManager
        super.init()
    }

    public func requestLocation() {
        locationManager.didChangeAuthorizationHandler = { [weak self] isPermitted in
            guard let self = self, isPermitted
            else {
                return
            }

            self.locationManager.requestLocation { [weak self] placemark in
                guard
                    let self = self,
                    let placemark = placemark,
                    let name = placemark.name,
                    let countryCode = placemark.isoCountryCode,
                    let locality    = placemark.locality,
                    let location    = placemark.location
                else {
                    return
                }

                let identifier = "\(name)_\(locality)_\(countryCode)".hashValue

                let city = City(
                    identifier: identifier,
                    name: locality,
                    country: countryCode,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )

                self.loadData(for: city)
            }
        }

        locationManager.requestAuthorization()
    }

    private func loadData(for city: City) {
        isLoading.value = true

        weatherApiManager.oneCallCurrentWeather(
            latitude: city.latitude,
            longitude: city.longitude
        ) { [weak self] response, error in
            guard let self = self else { return }

            defer {
                self.isLoading.value = false
            }

            guard
                let response = response,
                error == nil
            else {
                self.errorMessage.value = error?.localizedDescription
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
            self.reloadData.value = true
        }
    }
}
