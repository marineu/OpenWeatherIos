//
//  WeatherApiManager.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 04/05/2021.
//

import Foundation
import Alamofire

class WeatherApiManager: NSObject {

    static let shared = WeatherApiManager()

    override private init() {}

    public func oneCallCurrentWeather(
        latitude: Double,
        longitude: Double,
        excludedFieldTypes: [ExcludedFieldType] = []
    ) {
        var parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "appid": Constants.apiKey
        ]

        if !excludedFieldTypes.isEmpty {
            parameters["exclude"] = excludedFieldTypes
                .map { $0.rawValue }
                .joined(separator: ",")
        }

        let completionHandler: (DataResponse<OneCallResponse, AFError>) -> Void = { _ in }

        AF.request(
            Constants.oneCallBaseUrl,
            method: .get,
            parameters: parameters)
            .responseDecodable(of: OneCallResponse.self, completionHandler: completionHandler)
    }
}
