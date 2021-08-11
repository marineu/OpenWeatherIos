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

            let weatherPageViewController = WeatherPageViewController()
            weatherPageViewController
                .tabBarItem = UITabBarItem(
                    title: "Weather",
                    image: UIImage(named: "weather-tab-normal"),
                    selectedImage: UIImage(named: "weather-tab-selected")
                )

            UITabBar.appearance().unselectedItemTintColor = .doveGray
            UITabBar.appearance().tintColor = .dodgerBlue

            tabBarController.viewControllers = [weatherPageViewController]

            return tabBarController
        }
    }
}
