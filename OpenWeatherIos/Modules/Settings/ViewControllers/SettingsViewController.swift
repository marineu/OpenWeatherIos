//
//  SettingsViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import UIKit

class SettingsViewController: UIViewController, ViewModelNavigatorSupporting {

    private let unitTypeCellReuseIdentifier = String(describing: UnitTypeCell.self)
    private let tableViewCellReuseIdentifier = String(describing: UITableViewCell.self)

    var viewModel: SettingsViewModel?

    var navigator: SettingsNavigator?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.dataSource = self
        tableView.delegate   = self

        tableView.register(UnitTypeCell.self, forCellReuseIdentifier: unitTypeCellReuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellReuseIdentifier)

        return tableView
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"

        setupTableView()

        bindReloadTableView()
    }

    // MARK: - setup UI

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }

    // MARK: - bind UI

    private func bindReloadTableView() {
        viewModel?.reloadTableView.bind { [weak self] _ in
            guard let self = self else {
                return
            }

            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }

        return viewModel.headerModelList.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel?.headerModelList[section].rows.count ?? 0
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: unitTypeCellReuseIdentifier,
                for: indexPath
            ) as? UnitTypeCell

            cell?.rowModel = viewModel?.headerModelList[indexPath.section].rows[indexPath.row]

            return cell ?? UITableViewCell()
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: tableViewCellReuseIdentifier,
                for: indexPath
            )

            cell.textLabel?.text = "Data provided by OpenWeather"

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            guard let viewModel = viewModel else {
                return
            }

            let action: (UnitPickerViewModel.UniversalUnit, UnitType) -> Void = { unit, unitType in
                viewModel.updateUnit(unitRaw: unit.raw, unitType: unitType)
                NotificationCenter.default.post(name: .didChangeUnit, object: nil)
            }

            let rowModel = viewModel.headerModelList[indexPath.section].rows[indexPath.row]
            let unitType = rowModel.unitType
            var units: [UnitPickerViewModel.UniversalUnit] = []
            let settings = viewModel.appDataManager.settings
            var selectedUnit = UnitPickerViewModel.UniversalUnit()

            switch unitType {
            case .temperature:
                units = TemperatureUnit.allCases.map({
                    UnitPickerViewModel.UniversalUnit(raw: $0.rawValue, description: $0.description)
                })
                selectedUnit = UnitPickerViewModel.UniversalUnit(
                    raw: settings.temperatureUnit.rawValue,
                    description: settings.temperatureUnit.description
                )
            case .speed:
                units = SpeedUnit.allCases.map({
                    UnitPickerViewModel.UniversalUnit(raw: $0.rawValue, description: $0.description)
                })
                selectedUnit = UnitPickerViewModel.UniversalUnit(
                    raw: settings.speedUnit.rawValue,
                    description: settings.speedUnit.description
                )
            case .pressure:
                units = PressureUnit.allCases.map({
                    UnitPickerViewModel.UniversalUnit(raw: $0.rawValue, description: $0.description)
                })
                selectedUnit = UnitPickerViewModel.UniversalUnit(
                    raw: settings.pressureUnit.rawValue,
                    description: settings.pressureUnit.description
                )
            case .length:
                units = LengthUnit.allCases.map({
                    UnitPickerViewModel.UniversalUnit(raw: $0.rawValue, description: $0.description)
                })
                selectedUnit = UnitPickerViewModel.UniversalUnit(
                    raw: settings.lengthUnit.rawValue,
                    description: settings.lengthUnit.description
                )
            }

            let inputData = UnitPickerViewModel.InputData(
                units: units,
                selectedUnit: selectedUnit,
                unitType: unitType
            )
            navigator?.navigate(to: .unitPicker(inputData), action: .unitPickerDidSelectItem(action))
        default:
            if let url = URL(string: "https://openweathermap.org/api") {
                UIApplication.shared.open(url)
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return viewModel?.headerModelList[section].title
        default:
            return "Data"
        }
    }
}

extension Notification.Name {

    static let didChangeUnit = Notification.Name("didChangeUnit")
}
