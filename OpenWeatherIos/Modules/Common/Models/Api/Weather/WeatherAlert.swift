//
//  WeatherAlert.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/06/2021.
//

import Foundation

public struct WeatherAlert: Codable {

    /// Name of the alert source. Please read here the full list of alert sources
    var senderName: String

    /// Alert event name
    var event: String

    /// Date and time of the start of the alert, Unix, UTC
    var start: TimeInterval

    /// Date and time of the end of the alert, Unix, UTC
    var end: TimeInterval

    /// Description of the alert
    var description: String

    enum CodingKeys: String, CodingKey {

        case senderName = "sender_name"
        case event
        case start
        case end
        case description
    }
}
