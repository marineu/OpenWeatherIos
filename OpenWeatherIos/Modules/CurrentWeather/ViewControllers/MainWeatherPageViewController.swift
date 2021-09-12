//
//  MainWeatherPageViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 11/08/2021.
//

import UIKit

class MainWeatherPageViewController: WeatherPageViewController,
    ViewModelSupporting {

    var viewModel: MainWeatherPageViewModel?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let navigationBar = navigationController?.navigationBar

        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    override func pageViewController(
        _ pageViewController: UIPageViewController,
        didChangePageAt index: Int,
        withViewController: UIViewController
    ) {
        guard
            withViewController is CurrentWeatherController
        else {
            return
        }

        changeBackgroundType()
    }

    public func updateBackgroundView(with viewController: UIViewController) {
        guard
            viewController is CurrentWeatherController,
            allViewControllers[selectedIndex] == viewController
        else {
            return
        }

        changeBackgroundType()
    }

    private func initialize() {
        guard let viewModel = viewModel else {
            return
        }

        let viewControllers = viewModel.cityWeatherForecasts.map { item -> UIViewController in
            let viewModel = CurrentWeatherViewModel(
                appDataManager: AppDataManager.shared,
                weatherApiManager: WeatherApiManager.shared,
                cityWeatherForecast: item)
            let currentWeatherController = CurrentWeatherController()
            currentWeatherController.viewModel = viewModel
            currentWeatherController.navigator = CurrentWeatherNavigator(
                navigationController: navigationController
            )

            return currentWeatherController
        }

        setAllViewControllers(viewControllers)
    }

    private func changeBackgroundType() {
        guard
            let viewModel = viewModel
        else {
            return
        }

        let selectedCityWeatherForecast = viewModel.cityWeatherForecasts[selectedIndex]

        guard
            let current = selectedCityWeatherForecast.oneCallResponse.current,
            let firstWeather = current.weather.first
        else {
            return
        }

        let skyType = WeatherUtils(isNight: firstWeather.isNight).skyType(by: firstWeather.id)
        (view as? SkyView)?.skyType = skyType

        navigationItem.title = selectedCityWeatherForecast.city.name
    }
}
