//
//  MainNavigationController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 18/08/2021.
//

import UIKit

class MainNavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
