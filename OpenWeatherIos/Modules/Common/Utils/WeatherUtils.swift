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

    public func weatherIcon(by id: WeatherId) -> String {
        let imageNames: [Int: String] = [
            511: "rain-snow",
            800: isNight ? "clear-night" : "clear-day",
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
            return .sunnyDay
        }
    }
}
