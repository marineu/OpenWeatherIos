//
//  NavigatorSupporting.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 14/07/2021.
//

import Foundation

public protocol NavigatorSupporting {

    associatedtype Navigator

    var navigator: Navigator? { get set }
}
