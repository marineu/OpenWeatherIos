//
//  Temperature.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 04/05/2021.
//

import Foundation

public struct Temperature: MeasurableValue {
    
    public var value: Double = 0.0
    
    public init() {}
    
    static let zero = Temperature()
    
}
