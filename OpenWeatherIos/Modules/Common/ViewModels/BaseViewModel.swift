//
//  BaseViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/07/2021.
//

import Foundation

public class BaseViewModel {

    private(set) var errorMessage: Bindable<String?> = Bindable(nil)
    private(set) var isLoading: Bindable<Bool> = Bindable(false)
}
