//
//  Array+Ext.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/09/2021.
//

import Foundation

extension Array {

    public func filter(maxResultCount: Int, _ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        var result: [Element] = []

        for item in self {
            let isIncluded = try isIncluded(item)
            if isIncluded {
                result.append(item)
            }

            if result.count == maxResultCount {
                break
            }
        }

        return result
    }
}
