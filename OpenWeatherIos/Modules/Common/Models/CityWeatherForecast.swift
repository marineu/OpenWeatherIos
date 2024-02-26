//
//  CityWeatherForecast.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 12/07/2021.
//

import Foundation

public typealias CityWeatherForecasts = [CityWeatherForecast]

public struct CityWeatherForecast: Codable {

    var city: City
    var oneCallResponse: OneCallResponse
}
