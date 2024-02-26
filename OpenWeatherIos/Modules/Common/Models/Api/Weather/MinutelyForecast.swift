//
//  MinutelyForecast.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 05/05/2021.
//

import Foundation

public struct MinutelyForecast: Codable {

    /// ime of the forecasted data, unix, UTC
    var cdt: TimeInterval

    /// Precipitation volume, mm
    var precipitation: Double

    enum CodingKeys: String, CodingKey {

        case precipitation
        case cdt = "dt"
    }
}
