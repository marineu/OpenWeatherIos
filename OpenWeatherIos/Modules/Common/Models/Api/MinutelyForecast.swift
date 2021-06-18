//
//  MinutelyForecast.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 05/05/2021.
//

import Foundation

public struct MinutelyForecast: Codable {
    
    /// ime of the forecasted data, unix, UTC
    var dt: TimeInterval
    
    /// Precipitation volume, mm
    var precipitation: Double
    
}
