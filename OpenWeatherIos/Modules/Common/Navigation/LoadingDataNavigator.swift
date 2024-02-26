//
//  LoadingDataNavigator.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 14/07/2021.
//

import UIKit

class LoadingDataNavigator: Navigator {

    typealias OutputAction = Void

    enum Destination {
        case startApplication
    }

    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = viewController
    }

    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .startApplication:
            let tabBarController = UITabBarController()

            let weatherPageViewController = MainWeatherPageViewController()
            weatherPageViewController.viewModel = MainWeatherPageViewModel(
                appDataManager: AppDataManager.shared
            )
            weatherPageViewController
                .tabBarItem = UITabBarItem(
                    title: "Weather",
                    image: UIImage(named: "weather-tab-normal"),
                    selectedImage: UIImage(named: "weather-tab-selected")
                )

            let cityListViewController = LocationListViewController()
            cityListViewController.viewModel = LocationListViewModel(
                appDataManager: AppDataManager.shared,
                weatherApiManager: WeatherApiManager.shared
            )
            cityListViewController
                .tabBarItem = UITabBarItem(
                    title: "Locations",
                    image: UIImage(named: "locations-tab-normal"),
                    selectedImage: UIImage(named: "locations-tab-selected")
                )


            let settingsViewController = SettingsViewController()
            let settingsNavigationController = MainNavigationController(
                rootViewController: settingsViewController
            )
            settingsViewController.viewModel = SettingsViewModel(
                appDataManager: AppDataManager.shared
            )
            settingsViewController.navigator = SettingsNavigator(navigationController: settingsNavigationController)
            settingsViewController
                .tabBarItem = UITabBarItem(
                    title: "Settings",
                    image: UIImage(named: "settings-tab-normal"),
                    selectedImage: UIImage(named: "settings-tab-selected")
                )

            UITabBar.appearance().unselectedItemTintColor = .doveGray
            UITabBar.appearance().tintColor = .dodgerBlue
            UITabBar.appearance().isTranslucent = false

            tabBarController.viewControllers = [
                MainNavigationController(rootViewController: weatherPageViewController),
                MainNavigationController(rootViewController: cityListViewController),
                settingsNavigationController
            ]

            return tabBarController
        }
    }
}
