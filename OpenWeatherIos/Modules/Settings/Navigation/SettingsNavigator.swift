//
//  SettingsNavigator.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import UIKit

class SettingsNavigator: Navigator {

    enum Destination {
        case unitPicker(UnitPickerViewModel.InputData)
    }

    enum OutputAction {
        case unitPickerDidSelectItem((UnitPickerViewModel.UniversalUnit, UnitType) -> Void)
    }

    private var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func navigate(to destination: Destination, action: OutputAction) {
        switch destination {
        case .unitPicker(let inputData):
            switch action {
            case .unitPickerDidSelectItem(let action):
                let unitPickerViewController = UnitPickerViewController()
                unitPickerViewController.didTapDoneButtonHandler = { [weak self] unit, unitType in
                    guard let self = self else {
                        return
                    }

                    self.navigationController?.popViewController(animated: true)
                    action(unit, unitType)
                }
                unitPickerViewController.viewModel = UnitPickerViewModel(
                    inputData: inputData
                )

                navigationController?.pushViewController(unitPickerViewController, animated: true)
            }
        }
    }
}
