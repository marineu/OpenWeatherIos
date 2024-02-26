//
//  City.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 23/06/2021.
//

import Foundation

public typealias Cities = [City]

public struct City: Codable {

    var identifier: Int
    var name: String
    var country: String

    var latitude: Double
    var longitude: Double

    enum CodingKeys: String, CodingKey {

        case identifier = "id"
        case name
        case country

        case coord
    }

    enum AdditionalCodingKeys: String, CodingKey {

        case latitude  = "lat"
        case longitude = "lon"
    }

    public init(identifier: Int, name: String, country: String, latitude: Double, longitude: Double) {
        self.identifier = identifier
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        identifier = try values.decode(Int.self, forKey: .identifier)
        name       = try values.decode(String.self, forKey: .name)
        country    = try values.decode(String.self, forKey: .country)

        let coordContainer = try values
            .nestedContainer(keyedBy: AdditionalCodingKeys.self, forKey: .coord)
        latitude = try coordContainer.decode(Double.self, forKey: .latitude)
        longitude = try coordContainer.decode(Double.self, forKey: .longitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(identifier, forKey: .identifier)
        try container.encode(name, forKey: .name)
        try container.encode(country, forKey: .country)

        var coordContainer = container
            .nestedContainer(
                keyedBy: AdditionalCodingKeys.self,
                forKey: .coord)
        try coordContainer.encode(latitude, forKey: .latitude)
        try coordContainer.encode(longitude, forKey: .longitude)
    }
}
