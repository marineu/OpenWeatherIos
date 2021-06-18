//
//  WeatherModels.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/05/2021.
//

import Foundation

// MARK: - WeatherDetails

public struct WeatherDetails: Codable {
    
    /// Weather condition id
    var id: Int
    
    /// Group of weather parameters (Rain, Snow, Extreme etc.)
    var main: String
    
    /// Weather condition within the group (full list of weather conditions).
    var description: String
    
}
