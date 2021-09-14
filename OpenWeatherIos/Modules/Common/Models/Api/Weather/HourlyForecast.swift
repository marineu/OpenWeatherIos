//
//  HourlyForecast.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 05/05/2021.
//

import Foundation

public struct HourlyForecast: Codable, WeatherConvertible, WeatherTemperature {

    public var temperature: Temperature

    public var feelsLike: Temperature

    public var pop: Double

    public var cdt: TimeInterval

    public var pressure: Pressure

    public var humidity: Int8

    public var dewPoint: Temperature

    public var clouds: Int8

    public var uvi: Double

    public var visibility: Double

    public var windSpeed: WindSpeed

    public var windGust: WindSpeed?

    public var windDeg: Double

    public var weather: [WeatherDetails]

    public var rain: Double?

    public var snow: Double?

    enum CodingKeys: String, CodingKey {

        case temperature = "temp"
        case feelsLike   = "feels_like"

        case pop

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

    enum AdditionalCodingKeys: String, CodingKey {

        case lastHour = "1h"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        temperature = try values.decode(Temperature.self, forKey: .temperature)
        feelsLike = try values.decode(Temperature.self, forKey: .feelsLike)

        pop = try values.decode(Double.self, forKey: .pop)

        pressure  = try values.decode(Pressure.self, forKey: .pressure)
        dewPoint  = try values.decode(Temperature.self, forKey: .dewPoint)
        windSpeed = try values.decode(WindSpeed.self, forKey: .windSpeed)
        windGust  = try values.decodeIfPresent(WindSpeed.self, forKey: .windGust)

        cdt        = try values.decode(TimeInterval.self, forKey: .cdt)
        humidity   = try values.decode(Int8.self, forKey: .humidity)
        clouds     = try values.decode(Int8.self, forKey: .clouds)
        uvi        = try values.decode(Double.self, forKey: .uvi)
        visibility = try values.decode(Double.self, forKey: .visibility)
        windDeg    = try values.decode(Double.self, forKey: .windDeg)
        weather    = try values.decode([WeatherDetails].self, forKey: .weather)

        if values.contains(.rain) {
            let rainContainer = try values
                .nestedContainer(keyedBy: AdditionalCodingKeys.self, forKey: .rain)
            rain = try rainContainer.decode(Double.self, forKey: .lastHour)
        }

        if values.contains(.snow) {
            let snowContainer = try values
                .nestedContainer(keyedBy: AdditionalCodingKeys.self, forKey: .snow)
            snow = try snowContainer.decode(Double.self, forKey: .lastHour)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(temperature, forKey: .temperature)
        try container.encode(feelsLike, forKey: .feelsLike)

        try container.encode(pop, forKey: .pop)

        try container.encode(cdt, forKey: .cdt)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(dewPoint, forKey: .dewPoint)
        try container.encode(clouds, forKey: .clouds)
        try container.encode(uvi, forKey: .uvi)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(windSpeed, forKey: .windSpeed)
        try container.encodeIfPresent(windGust, forKey: .windGust)
        try container.encode(windDeg, forKey: .windDeg)
        try container.encode(weather, forKey: .weather)

        if let rain = rain {
            var rainContainer = container
                .nestedContainer(
                    keyedBy: AdditionalCodingKeys.self,
                    forKey: .rain)
            try rainContainer.encode(rain, forKey: .lastHour)
        }

        if let snow = snow {
            var snowContainer = container
                .nestedContainer(
                    keyedBy: AdditionalCodingKeys.self,
                    forKey: .snow)
            try snowContainer.encode(snow, forKey: .lastHour)
        }
    }
}
