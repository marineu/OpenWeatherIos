//
//  Constants.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 02/05/2021.
//

import Foundation

class Constants: NSObject {

    static let apiKey = "Your API key"

    static let oneCallBaseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    static let citiesListUtl = "http://bulk.openweathermap.org/sample/city.list.min.json.gz"

    static let citiesDataFileName = "cities_data"
    static let settingsDataFileName = "settings_data"
    static let cityWeatherDataFileName = "cityWeather_data"
}
