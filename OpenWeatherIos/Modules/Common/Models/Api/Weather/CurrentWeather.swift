//
//  CurrentWeather.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 04/05/2021.
//

import Foundation

public struct CurrentWeather: Codable, WeatherConvertible, WeatherTemperature {

    public var temperature: Temperature

    public var feelsLike: Temperature

    public var sunrise: TimeInterval

    public var sunset: TimeInterval

    public var cdt: TimeInterval

    public var pressure: Pressure

    public var humidity: Int8

    public var dewPoint: Temperature

    public var clouds: Int8

    public var uvi: Double

    public var visibility: Double

    public var windSpeed: WindSpeed

    public var windGust: WindSpeed

    public var windDeg: Double

    public var weather: [WeatherDetails]

    public var rain: Double?

    public var snow: Double?

    enum CodingKeys: String, CodingKey {

        case temperature = "temp"
        case feelsLike   = "feels_like"

        case sunrise
        case sunset

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

        let temperatureValue = try values.decode(Double.self, forKey: .temperature)
        temperature = Temperature(value: temperatureValue)

        let feelsLikeValue = try values.decode(Double.self, forKey: .feelsLike)
        feelsLike = Temperature(value: feelsLikeValue)

        sunrise = try values.decode(TimeInterval.self, forKey: .sunrise)
        sunset  = try values.decode(TimeInterval.self, forKey: .sunset)

        let pressureValue = try values.decode(Double.self, forKey: .pressure)
        pressure          = Pressure(value: pressureValue)

        let dewPointValue = try values.decode(Double.self, forKey: .dewPoint)
        dewPoint          = Temperature(value: dewPointValue)

        let windSpeedValue = try values.decode(Double.self, forKey: .windSpeed)
        windSpeed          = WindSpeed(value: windSpeedValue)

        let windGustValue = try values.decode(Double.self, forKey: .windGust)
        windGust          = WindSpeed(value: windGustValue)

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

        try container.encode(temperature.value, forKey: .temperature)
        try container.encode(feelsLike.value, forKey: .feelsLike)

        try container.encode(sunrise, forKey: .sunrise)
        try container.encode(sunset, forKey: .sunset)

        try container.encode(cdt, forKey: .cdt)
        try container.encode(pressure.value, forKey: .pressure)
        try container.encode(humidity, forKey: .humidity)
        try container.encode(dewPoint.value, forKey: .dewPoint)
        try container.encode(clouds, forKey: .clouds)
        try container.encode(uvi, forKey: .uvi)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(windSpeed.value, forKey: .windSpeed)
        try container.encode(windGust.value, forKey: .windGust)
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
