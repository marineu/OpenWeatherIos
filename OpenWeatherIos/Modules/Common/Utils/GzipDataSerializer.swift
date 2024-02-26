//
//  GzipDataSerializer.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 30/06/2021.
//

import Foundation
import Alamofire

struct GzipDataSerializer: ResponseSerializer {

    typealias SerializedObject = Data

    func serialize(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?
    ) throws -> Data {
        let compressedData =
            try DataResponseSerializer().serialize(request: request, response: response, data: data, error: error)

        return try compressedData.gunzip()
    }
}
