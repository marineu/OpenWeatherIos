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
        excludedFieldTypes: [ExcludedFieldType] = [],
        completion: ((OneCallResponse?, Error?) -> Void)?
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

        let completionHandler: (DataResponse<OneCallResponse, AFError>) -> Void = { response in
            switch response.result {
            case .success(let oneCallResponse):
                completion?(oneCallResponse, nil)
            case .failure(let error):
                completion?(nil, error)
            }
        }

        AF.request(
            Constants.oneCallBaseUrl,
            method: .get,
            parameters: parameters
        )
        .validate(statusCode: 200..<309)
        .responseDecodable(of: OneCallResponse.self, completionHandler: completionHandler)
    }

    public func getAllCities(completion: ((Cities, Error?) -> Void)?) {
        AF.request(
            Constants.citiesListUtl,
            method: .get
        )
        .validate(statusCode: 200..<309)
        .responseGzipDecodable(of: Cities.self) { response in
            switch response.result {
            case .success(let cities):
                completion?(cities, nil)
            case .failure(let error):
                completion?([], error)
            }
        }
    }
}
