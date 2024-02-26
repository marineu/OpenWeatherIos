//
//  OneCallResponse.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 04/05/2021.
//

import Foundation

public struct OneCallResponse: Codable {

    /// Geographical coordinates of the location (latitude)
    var latitude: Double

    /// Geographical coordinates of the location (longitude)
    var longitude: Double

    /// Timezone name for the requested location
    var timezone: String

    /// Shift in seconds from UTC
    var timezoneOffset: Int

    /// Current weather data API response
    var current: CurrentWeather?

    /// Minute forecast weather data API response
    var minutely: [MinutelyForecast]?

    /// Hourly forecast weather data API response
    var hourly: [HourlyForecast]?

    /// Daily forecast weather data API response
    var daily: [DailyForecast]?

    /// National weather alerts data from major national weather warning systems
    var alerts: [WeatherAlert]?

    enum CodingKeys: String, CodingKey {

        case latitude = "lat"
        case longitude = "lon"

        case timezone
        case timezoneOffset = "timezone_offset"

        case current
        case minutely
        case hourly
        case daily
        case alerts
    }

    init() {
        latitude       = .infinity
        longitude      = .infinity
        timezone       = ""
        timezoneOffset = 0
    }
}
