//
//  DataRequest+Gzip.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 30/06/2021.
//

import Foundation
import Alamofire

extension DataRequest {

    @discardableResult
    func responseGzipDecodable<T: Decodable>(
        queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated),
        of type: T.Type,
        decoder: DataDecoder = JSONDecoder(),
        completionHandler: @escaping (DataResponse<T, Error>) -> Void
    ) -> Self {
        return response(queue: queue, responseSerializer: GzipDataSerializer()) { response in
            let transformedResponse = response.tryMap { data in
                try decoder.decode(type, from: data)
            }

            completionHandler(transformedResponse)
        }
    }
}
