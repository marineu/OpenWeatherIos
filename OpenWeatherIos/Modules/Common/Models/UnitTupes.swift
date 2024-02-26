//
//  UnitTupes.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 10/07/2021.
//

import Foundation

public enum TemperatureUnit: Int, Codable, CaseIterable {

    case celsius
    case fahrenheit
}

extension TemperatureUnit: CustomStringConvertible {

    public var description: String {
        switch self {
        case .celsius:
            return "Celsius (\(UnitTemperature.celsius.symbol))"
        case .fahrenheit:
            return "Fahrenheit (\(UnitTemperature.fahrenheit.symbol))"
        }
    }
}

public enum SpeedUnit: Int, Codable, CaseIterable {

    case metersPerSecond
    case kilometersPerHour
    case milesPerHour
    case knots
}

extension SpeedUnit: CustomStringConvertible {

    public var description: String {
        switch self {
        case .metersPerSecond:
            return "Meters per second (\(UnitSpeed.metersPerSecond.symbol))"
        case .kilometersPerHour:
            return "Kilometers per hour (\(UnitSpeed.kilometersPerHour.symbol))"
        case .milesPerHour:
            return "Miles per hour (\(UnitSpeed.milesPerHour.symbol))"
        case .knots:
            return "Knots (\(UnitSpeed.knots.symbol))"
        }
    }
}

public enum PressureUnit: Int, Codable, CaseIterable {

    case hectopascals
    case millibars
    case millimetersOfMercury
    case inchesOfMercury
}

extension PressureUnit: CustomStringConvertible {

    public var description: String {
        switch self {
        case .hectopascals:
            return "Hectopascals (\(UnitPressure.hectopascals.symbol))"
        case .millibars:
            return "Millibars (\(UnitPressure.millibars.symbol))"
        case .millimetersOfMercury:
            return "Millimeters of mercury (\(UnitPressure.millimetersOfMercury.symbol))"
        case .inchesOfMercury:
            return "Inches of mercury (\(UnitPressure.inchesOfMercury.symbol))"
        }
    }
}

public enum LengthUnit: Int, Codable, CaseIterable {

    case meters
    case kilometers
    case yards
    case miles
}

extension LengthUnit: CustomStringConvertible {

    public var description: String {
        switch self {
        case .meters:
            return "Meters (\(UnitLength.meters.symbol))"
        case .kilometers:
            return "Kilometers (\(UnitLength.kilometers.symbol))"
        case .yards:
            return "Yards (\(UnitLength.yards.symbol))"
        case .miles:
            return "Miles (\(UnitLength.miles.symbol))"
        }
    }
}

public enum UnitType: Int, CustomStringConvertible, CaseIterable {
    case temperature
    case speed
    case pressure
    case length

    public var description: String {
        switch self {
        case .temperature:
            return "Temperature units"
        case .speed:
            return "Wind speed units"
        case .pressure:
            return "Atmospheric pressure units"
        case .length:
            return "Length units"
        }
    }
}
