//
//  ViewModelSupporting.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/07/2021.
//

import Foundation

public protocol ViewModelSupporting {

    associatedtype ViewModel

    var viewModel: ViewModel? { get set }
}
