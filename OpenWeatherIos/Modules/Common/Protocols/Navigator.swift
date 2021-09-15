//
//  Navigator.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 14/07/2021.
//

import Foundation

public protocol Navigator {

    associatedtype Destination
    associatedtype OutputAction

    func navigate(to destination: Destination)
    func navigate(to destination: Destination, action: OutputAction)
}

extension Navigator {

    func navigate(to destination: Destination) {
    }

    func navigate(to destination: Destination, action: OutputAction) {
    }
}
