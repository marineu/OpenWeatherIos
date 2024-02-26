//
//  ValueStoreService.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 09/07/2021.
//

import Foundation

class ValueStoreService<V: Codable> {

    typealias Value = V

    private var fileName: String

    lazy private(set) var storageFileUrl: URL = {
        let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent(fileName)
    }()

    private var decoder: JSONDecoder

    var value: Value?

    init(fileName: String, decoder: JSONDecoder = JSONDecoder()) {
        self.fileName = fileName
        self.decoder = decoder

        value = initialize()
    }

    @discardableResult
    public func synchronize(encoder: JSONEncoder = JSONEncoder()) -> Bool {
        do {
            let data = try encoder.encode(value)
            try data.write(to: storageFileUrl)

            return true
        } catch {
            return false
        }
    }

    private func initialize() -> Value? {
        do {
            let data = try Data(contentsOf: storageFileUrl)
            let value = try decoder.decode(Value.self, from: data)

            return value
        } catch {
            return nil
        }
    }
}
