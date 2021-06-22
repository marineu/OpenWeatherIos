//
//  CurrentWeatherController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 02/05/2021.
//

import UIKit

class CurrentWeatherController: UIViewController {

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBackground

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        WeatherApiManager.shared.oneCallCurrentWeather(latitude: 46.35, longitude: 9.18)
        WeatherApiManager.shared.getAllCountries()
    }
}
