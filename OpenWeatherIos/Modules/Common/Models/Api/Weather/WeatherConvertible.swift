//
//  WeatherConvertible.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/05/2021.
//

import Foundation

public protocol WeatherConvertible {

    /// Current time, Unix, UTC
    var cdt: TimeInterval { get set }

    /// Sunrise time, Unix, UTC
    var sunrise: TimeInterval { get set }

    /// Sunset time, Unix, UTC
    var sunset: TimeInterval { get set }

    /// The time of when the moon rises for this day, Unix, UTC
    var moonrise: TimeInterval { get set }

    /// The time of when the moon sets for this day, Unix, UTC
    var moonset: TimeInterval { get set }

    /// Probability of precipitation
    var pop: Double { get set }

    /// Moon phase. 0 and 1 are 'new moon', 0.25 is 'first quarter moon', 0.5 is 'full moon' and 0.75 is 'last quarter moon'. The periods in between are called 'waxing crescent', 'waxing gibous', 'waning gibous', and 'waning crescent', respectively.
    var moonPhase: Double { get set }

    /// Atmospheric pressure on the sea level.
    var pressure: Pressure { get set }

    /// Humidity, %
    var humidity: Int8 { get set }

    /// Atmospheric temperature (varying according to pressure and humidity) below which water droplets begin to condense and dew can form.
    var dewPoint: Temperature { get set }

    /// Cloudiness, %
    var clouds: Int8 { get set }

    /// Current UV index
    var uvi: Double { get set }

    /// Average visibility, metres
    var visibility: Double { get set }

    /// Wind speed.
    var windSpeed: WindSpeed { get set }

    /// (where available) Wind gust.
    var windGust: WindSpeed? { get set }

    /// Wind direction, degrees (meteorological)
    var windDeg: Double { get set }

    var weather: [WeatherDetails] { get set }

    var rain: Double? { get set }

    var snow: Double? { get set }
}

public protocol WeatherTemperature {

    /// Temperature.
    var temperature: Temperature { get set }

    /// Temperature. This temperature parameter accounts for the human perception of weather.
    var feelsLike: Temperature { get set }
}

extension WeatherConvertible {

    public var sunrise: TimeInterval { get { return 0 } set { _ = newValue } }
    public var sunset: TimeInterval { get { return 0 } set { _ = newValue } }
    public var moonrise: TimeInterval { get { return 0 } set { _ = newValue } }
    public var moonset: TimeInterval { get { return 0 } set { _ = newValue } }
    public var pop: Double { get { return 0 } set { _ = newValue } }
    public var moonPhase: Double { get { return 0 } set { _ = newValue } }
}
