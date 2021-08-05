//
//  WeatherUtils.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 27/07/2021.
//

import Foundation

public class WeatherUtils {

    private(set) var sunset: TimeInterval

    init(sunset: TimeInterval) {
        self.sunset = sunset
    }

    var isNight: Bool {
        return Date().timeIntervalSince1970 > sunset
    }

    public func weatherIcon(by id: Int) -> String {
        let imageNames: [Int: String] = [
            511: "rain-snow",
            800: isNight ? "clear-night" : "clear-day",
            801: isNight ? "mostly-clear-night" : "mostly-sunny-day",
            802: "cloudy",
            803: isNight ? "partly-cloudy-night" : "partly-cloudy-day",
            804: isNight ? "mostly-cloudy-night" : "mostly-cloudy-day"
        ]

        switch id {
        case 200..<300:
            return "thunderstorms"
        case 300..<400:
            return "rain"
        case 500..<505:
            return "light-rain"
        case 520..<600:
            return "rain"
        case 600..<700:
            return "snow"
        case 700..<800:
            return "mist"
        default:
            return imageNames[id] ?? ""
        }
    }
}
