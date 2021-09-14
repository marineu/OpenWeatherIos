//
//  DailyForecast.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/05/2021.
//

import Foundation

public struct DailyForecast: Codable, WeatherConvertible {

    var dailyTemperature: DailyTemperature

    var dailyFeelsLike: DailyTemperature

    public var pop: Double

    public var cdt: TimeInterval

    public var sunrise: TimeInterval

    public var sunset: TimeInterval

    public var moonrise: TimeInterval

    public var moonset: TimeInterval

    public var moonPhase: Double

    public var pressure: Pressure

    public var humidity: Int8

    public var dewPoint: Temperature

    public var clouds: Int8

    public var uvi: Double

    public var visibility: Double = 0

    public var windSpeed: WindSpeed

    public var windGust: WindSpeed?

    public var windDeg: Double

    public var weather: [WeatherDetails]

    public var rain: Double?

    public var snow: Double?

    enum CodingKeys: String, CodingKey {

        case dailyTemperature = "temp"
        case dailyFeelsLike   = "feels_like"

        case pop
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase = "moon_phase"

        case cdt = "dt"
        case pressure  = "pressure"
        case humidity
        case dewPoint  = "dew_point"
        case clouds
        case uvi
        case visibility
        case windSpeed = "wind_speed"
        case windGust  = "wind_gust"
        case windDeg   = "wind_deg"
        case weather

        case rain
        case snow
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        dailyTemperature = try values.decode(
            DailyTemperature.self,
            forKey: .dailyTemperature)
        dailyFeelsLike = try values.decode(
            DailyTemperature.self,
            forKey: .dailyFeelsLike)

        pop       = try values.decode(Double.self, forKey: .pop)
        sunrise   = try values.decode(Double.self, forKey: .sunrise)
        sunset    = try values.decode(Double.self, forKey: .sunset)
        moonrise  = try values.decode(Double.self, forKey: .moonrise)
        moonset   = try values.decode(Double.self, forKey: .moonset)
        moonPhase = try values.decode(Double.self, forKey: .moonPhase)

        pressure  = try values.decode(Pressure.self, forKey: .pressure)
        dewPoint  = try values.decode(Temperature.self, forKey: .dewPoint)
        windSpeed = try values.decode(WindSpeed.self, forKey: .windSpeed)
        windGust  = try values.decodeIfPresent(WindSpeed.self, forKey: .windGust)

        cdt      = try values.decode(TimeInterval.self, forKey: .cdt)
        humidity = try values.decode(Int8.self, forKey: .humidity)
        clouds   = try values.decode(Int8.self, forKey: .clouds)
        uvi      = try values.decode(Double.self, forKey: .uvi)
        windDeg  = try values.decode(Double.self, forKey: .windDeg)
        weather  = try values.decode([WeatherDetails].self, forKey: .weather)
        rain     = try values.decodeIfPresent(Double.self, forKey: .rain)
        snow     = try values.decodeIfPresent(Double.self, forKey: .snow)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(dailyTemperature, forKey: .dailyTemperature)
        try container.encode(dailyFeelsLike, forKey: .dailyFeelsLike)

        try container.encode(pop, forKey: .pop)
        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)
        try container.encode(moonrise, forKey: .moonrise)
        try container.encode(moonset, forKey: .moonset)
        try container.encode(moonPhase, forKey: .moonPhase)

        try container.encode(cdt, forKey: .cdt)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(dewPoint, forKey: .dewPoint)
        try container.encode(clouds, forKey: .clouds)
        try container.encode(uvi, forKey: .uvi)
        try container.encode(windSpeed, forKey: .windSpeed)
        try container.encodeIfPresent(windGust, forKey: .windGust)
        try container.encode(windDeg, forKey: .windDeg)
        try container.encode(weather, forKey: .weather)
        try container.encodeIfPresent(rain, forKey: .rain)
        try container.encodeIfPresent(snow, forKey: .snow)
    }
}

// MARK: - DailyTemperature

extension DailyForecast.DailyTemperature {

    enum CodingKeys: String, CodingKey {
        case morning = "morn"
        case day
        case evening = "eve"
        case night
        case min
        case max
    }
}

extension DailyForecast {

    struct DailyTemperature: Codable {

        /// Morning temperature.
        var morning: Temperature

        /// Day temperature.
        var day: Temperature

        /// Evening temperature.
        var evening: Temperature

        /// Night temperature.
        var night: Temperature

        /// Min daily temperature.
        var min: Temperature?

        /// Max daily temperature.
        var max: Temperature?

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)

            morning = try values.decode(Temperature.self, forKey: .morning)
            day     = try values.decode(Temperature.self, forKey: .day)
            evening = try values.decode(Temperature.self, forKey: .evening)
            night   = try values.decode(Temperature.self, forKey: .night)

            min = try values.decodeIfPresent(Temperature.self, forKey: .min)
            max = try values.decodeIfPresent(Temperature.self, forKey: .max)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(morning, forKey: .morning)
            try container.encode(day, forKey: .day)
            try container.encode(evening, forKey: .evening)
            try container.encode(night, forKey: .night)
            try container.encodeIfPresent(min, forKey: .min)
            try container.encodeIfPresent(max, forKey: .max)
        }
    }
}
