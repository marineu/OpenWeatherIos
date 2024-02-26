//
//  LoadingDataViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/07/2021.
//

import Foundation

public class LoadingDataViewModel: BaseViewModel {

    private(set) var retryButtonIsHidden: Bindable<Bool> = Bindable(true)
    public var didLoadData: (() -> Void)?

    public func loadData() {
        isLoading.value = true

        let cities = AppDataManager.shared.cityStoreService.value ?? []

        guard cities.isEmpty else {
            isLoading.value = false
            self.didLoadData?()
            return
        }

        WeatherApiManager.shared.getAllCities { [weak self] cities, error in
            guard let self = self else { return }

            defer {
                DispatchQueue.main.async {
                    self.isLoading.value = false
                    self.errorMessage.value = error != nil ? error?.localizedDescription : nil
                    self.retryButtonIsHidden.value = error == nil

                    if error == nil {
                        self.didLoadData?()
                    }
                }
            }

            guard error == nil else {
                return
            }

            AppDataManager.shared.cityStoreService.value = cities
        }
    }
}
