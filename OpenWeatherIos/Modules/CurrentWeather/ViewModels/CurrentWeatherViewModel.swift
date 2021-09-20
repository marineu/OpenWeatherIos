//
//  CurrentWeatherViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 14/08/2021.
//

import Foundation

enum CellType: String {
    case current
    case currentAdditional
    case hourly
    case daily
    case sunset
}

public class CurrentWeatherViewModel: BaseViewModel {

    private(set) var appDataManager: AppDataManager
    private let weatherApiManager: WeatherApiManager

    private(set) var reloadTableView: Bindable<()>
    private(set) var cityWeatherForecast: CityWeatherForecast {
        didSet {
            cellTypes = [.current, .daily]
            if hourlyForecasts.isEmpty == false {
                cellTypes.append(.hourly)
            }
            cellTypes.append(.currentAdditional)
            cellTypes.append(.sunset)
            reloadTableView.value = ()
        }
    }

    var hourlyForecasts: [HourlyForecast] {
        let hourly = cityWeatherForecast.oneCallResponse.hourly ?? []

        var calendar = Calendar.current
        calendar.timeZone = timeZone
        let now = Date()

        let items = hourly
            .filter {
                let date = Date(timeIntervalSince1970: $0.cdt)
                return calendar.compare(now, to: date, toGranularity: .hour) != .orderedDescending
            }

        return items
    }

    var timeZone: TimeZone {
        let timeZone = cityWeatherForecast.oneCallResponse.timezone
        return TimeZone(identifier: timeZone) ?? TimeZone.current
    }

    private(set) var cellTypes: [CellType] = [.current, .daily]

    init(appDataManager: AppDataManager, weatherApiManager: WeatherApiManager, cityWeatherForecast: CityWeatherForecast) {
        self.appDataManager = appDataManager
        self.weatherApiManager = weatherApiManager

        reloadTableView = Bindable(())
        self.cityWeatherForecast = cityWeatherForecast
    }

    public func loadData() {
        let city = cityWeatherForecast.city

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

            let index = cityWeathers.firstIndex { $0.city.identifier == city.identifier }
            guard let index = index else {
                return
            }

            let cityWeatherForecast = CityWeatherForecast(city: city, oneCallResponse: response)
            cityWeathers[index] = cityWeatherForecast
            self.appDataManager.setCityWeatherStoreServiceValue(cityWeathers)

            self.cityWeatherForecast = cityWeatherForecast
        }
    }
}
