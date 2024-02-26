//
//  Settings.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 10/07/2021.
//

import Foundation

public struct Settings: Codable {

    var temperatureUnit: TemperatureUnit
    var speedUnit: SpeedUnit
    var pressureUnit: PressureUnit
    var lengthUnit: LengthUnit

    init() {
        temperatureUnit = .celsius
        speedUnit       = .kilometersPerHour
        pressureUnit    = .hectopascals
        lengthUnit      = .meters
    }
}
