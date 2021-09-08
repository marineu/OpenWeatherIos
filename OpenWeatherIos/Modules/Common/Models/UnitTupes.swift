//
//  UnitTupes.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 10/07/2021.
//

import Foundation

public enum TemperatureUnit: Int, Codable {

    case celsius
    case fahrenheit
}

public enum SpeedUnit: Int, Codable {

    case metersPerSecond
    case kilometersPerHour
    case milesPerHour
    case knots
}

public enum PressureUnit: Int, Codable {

    case hectopascals
    case millibars
    case millimetersOfMercury
    case inchesOfMercury
}

public enum LengthUnit: Int, Codable {

    case meters
    case kilometers
    case yards
    case miles
}
