//
//  MeasurableValue.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/06/2021.
//

import Foundation

public protocol MeasurableValue {

    var value: Double { get set }

    init()

    init(value: Double)
}

extension MeasurableValue {

    public init(value: Double) {
        self.init()
        self.value = value
    }
}
