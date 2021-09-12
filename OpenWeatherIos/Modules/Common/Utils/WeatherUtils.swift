//
//  WeatherUtils.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 27/07/2021.
//

import Foundation

public class WeatherUtils {

    let isNight: Bool

    init(isNight: Bool) {
        self.isNight = isNight
    }

    init() {
        isNight = false
    }

    public func weatherIcon(by id: WeatherId) -> String {
        let imageNames: [Int: String] = [
            511: "rain-snow",
            800: isNight ? "clear-night" : "sunny-day",
            801: isNight ? "mostly-clear-night" : "mostly-sunny-day",
            802: "cloudy",
            803: isNight ? "partly-cloudy-night" : "partly-cloudy-day",
            804: isNight ? "mostly-cloudy-night" : "mostly-cloudy-day"
        ]

        switch id {
        case 200..<233:
            return "thunderstorms"
        case 300..<322, 520..<532:
            return "rain"
        case 500..<505:
            return "light-rain"
        case 600..<623:
            return "snow"
        case 701..<782:
            return "mist"
        default:
            return imageNames[id] ?? ""
        }
    }

    public func skyType(by id: WeatherId) -> SkyType {
        switch id {
        case 200..<322, 500..<505, 520..<532:
            return isNight ? .rainyNight : .rainyDay
        case 511, 600..<623:
            return isNight ? .snowyIcyNight : .snowyIcyDay
        case 800:
            return isNight ? .clearNight : .sunnyDay
        case 701..<800, 801..<805:
            return isNight ? .cloudyFoggyNight : .cloudyFoggyDay
        default:
            return .default
        }
    }

    public func windSpeedDescription(by windSpeed: WindSpeed) -> String {
        switch windSpeed {
        case 0.0..<0.3:
            return "Calm"
        case 0.3..<1.6:
            return "Light air"
        case 1.6..<3.4:
            return "Light breeze"
        case 3.4..<5.5:
            return "Gentle Breeze"
        case 5.5..<8.0:
            return "Moderate breeze"
        case 8.0..<10.8:
            return "Fresh Breeze"
        case 10.8..<13.9:
            return "Strong breeze"
        case 13.9..<17.2:
            return "High wind, near gale"
        case 17.2..<20.7:
            return "Gale"
        case 20.8..<24.5:
            return "Severe Gale"
        case 24.5..<28.5:
            return "Storm"
        case 28.5..<32.7:
            return "Violent Storm"
        default:
            return "Hurricane"
        }
    }

    public func windDirectionShort(by windDeg: Double) -> String {
        switch windDeg {
        case -11.25..<11.25:
            return "N"
        case 11.25..<33.75:
            return "NNE"
        case 33.75..<56.25:
            return "NE"
        case 56.25..<78.75:
            return "ENE"
        case 78.75..<101.25:
            return "E"
        case 101.25..<123.75:
            return "ESE"
        case 123.75..<146.25:
            return "SE"
        case 146.25..<168.75:
            return "SSE"
        case 168.75..<191.25:
            return "S"
        case 191.25..<213.75:
            return "SSW"
        case 213.75..<236.25:
            return "SW"
        case 236.25..<258.75:
            return "WSW"
        case 258.75..<281.25:
            return "W"
        case 281.25..<303.75:
            return "WNW"
        case 303.75..<326.25:
            return "NW"
        case 326.25..<348.75:
            return "NNW"
        default:
            return ""
        }
    }

    public func moonPhaseDescription(by moonPhase: Double) -> String {
        switch moonPhase {
        case 0..<0.25:
            return moonPhase == 0 ? "New moon" : "Waxing crescent"
        case 0.25..<0.5:
            return moonPhase == 0.25 ? "First quarter moon" : "Waxing gibous"
        case 0.5..<0.75:
            return moonPhase == 0.5 ? "Full moon" : "Waning gibous"
        case 0.75..<1:
            return moonPhase == 0.75 ? "Last quarter moon" : "Waning crescent"
        case 1:
            return "New moon"
        default:
            return ""
        }
    }
}

// MARK: - measurement formatter

extension WeatherUtils {

    public func humanReadableTemperature(
        value: Temperature?,
        by temperatureUnit: TemperatureUnit,
        showUnit: Bool = true
    ) -> String {
        guard let value = value else {
            return "--"
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.roundingMode = .up

        let formatter = MeasurementFormatter()
        formatter.unitOptions = showUnit ? .providedUnit : .temperatureWithoutUnit
        formatter.numberFormatter = numberFormatter

        var measurement = Measurement(value: value, unit: UnitTemperature.kelvin)

        switch temperatureUnit {
        case .celsius:
            measurement.convert(to: .celsius)
            return formatter.string(from: measurement)
        case .fahrenheit:
            measurement.convert(to: .fahrenheit)
            return formatter.string(from: measurement)
        }
    }

    public func humanReadableWindSpeed(
        value: WindSpeed,
        by speedUnit: SpeedUnit
    ) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter = numberFormatter

        var measurement = Measurement(value: value, unit: UnitSpeed.metersPerSecond)

        switch speedUnit {
        case .metersPerSecond:
            return formatter.string(from: measurement)
        case .kilometersPerHour:
            measurement.convert(to: .kilometersPerHour)
            return formatter.string(from: measurement)
        case .milesPerHour:
            measurement.convert(to: .milesPerHour)
            return formatter.string(from: measurement)
        case .knots:
            measurement.convert(to: .knots)
            return formatter.string(from: measurement)
        }
    }

    public func humanReadableLength(
        value: Double,
        by lengthUnit: LengthUnit
    ) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter = numberFormatter

        var measurement = Measurement(value: value, unit: UnitLength.meters)

        switch lengthUnit {
        case .meters:
            return formatter.string(from: measurement)
        case .kilometers:
            measurement.convert(to: .kilometers)
            return formatter.string(from: measurement)
        case .yards:
            measurement.convert(to: .yards)
            return formatter.string(from: measurement)
        case .miles:
            measurement.convert(to: .miles)
            return formatter.string(from: measurement)
        }
    }

    public func humanReadablePressure(
        value: Pressure,
        by pressureUnit: PressureUnit
    ) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1

        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter = numberFormatter

        var measurement = Measurement(value: value, unit: UnitPressure.hectopascals)

        switch pressureUnit {
        case .hectopascals:
            return formatter.string(from: measurement)
        case .millibars:
            measurement.convert(to: .millibars)
            return formatter.string(from: measurement)
        case .millimetersOfMercury:
            measurement.convert(to: .millimetersOfMercury)
            return formatter.string(from: measurement)
        case .inchesOfMercury:
            measurement.convert(to: .inchesOfMercury)
            return formatter.string(from: measurement)
        }
    }
}
