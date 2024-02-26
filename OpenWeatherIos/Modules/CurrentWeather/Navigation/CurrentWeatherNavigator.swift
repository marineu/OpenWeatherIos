//
//  CurrentWeatherNavigator.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 09/09/2021.
//

import UIKit

class CurrentWeatherNavigator: Navigator {

    typealias OutputAction = Void

    enum Destination {
        case dailyForecast((dailyForecast: [DailyForecast], timeZone: TimeZone))
    }

    private var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .dailyForecast(let params):
            let dailyForecastViewController = DailyForecastViewController()
            dailyForecastViewController.viewModel = DailyForecastViewModel(
                appDataManager: AppDataManager.shared,
                dailyForecasts: params.dailyForecast,
                timeZone: params.timeZone
            )

            navigationController?.pushViewController(dailyForecastViewController, animated: true)
        }
    }
}
