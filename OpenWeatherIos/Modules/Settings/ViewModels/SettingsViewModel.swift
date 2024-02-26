//
//  SettingsViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import Foundation

public class SettingsViewModel: BaseViewModel {

    private(set) var reloadTableView: Bindable<()> = Bindable(())

    let appDataManager: AppDataManager

    var headerModelList: [HeaderModel] = [] {
        didSet {
            reloadTableView.value = ()
        }
    }

    init(appDataManager: AppDataManager) {
        self.appDataManager = appDataManager
        super.init()
        headerModelList = initializeTableViewData()
    }

    public func updateUnit(unitRaw: Int, unitType: UnitType) {
        var settings = appDataManager.settings

        switch unitType {
        case .temperature:
            guard let unit = TemperatureUnit(rawValue: unitRaw) else {
                return
            }
            settings.temperatureUnit = unit
        case .speed:
            guard let unit = SpeedUnit(rawValue: unitRaw) else {
                return
            }
            settings.speedUnit = unit
        case .pressure:
            guard let unit = PressureUnit(rawValue: unitRaw) else {
                return
            }
            settings.pressureUnit = unit
        case .length:
            guard let unit = LengthUnit(rawValue: unitRaw) else {
                return
            }
            settings.lengthUnit = unit
        }

        appDataManager.setSettingsStoreServiceValue(settings)

        headerModelList = initializeTableViewData()
    }

    private func initializeTableViewData() -> [HeaderModel] {
        var headerModelList: [HeaderModel] = []

        var rows: [RowModel] = []
        for unitType in UnitType.allCases {
            var value = ""
            switch unitType {
            case .temperature:
                value = appDataManager.settings.temperatureUnit.description
            case .speed:
                value = appDataManager.settings.speedUnit.description
            case .pressure:
                value = appDataManager.settings.pressureUnit.description
            case .length:
                value = appDataManager.settings.lengthUnit.description
            }

            let rowModel = RowModel(title: unitType.description, value: value, unitType: unitType)
            rows.append(rowModel)
        }

        if rows.isEmpty == false {
            let headerModel = HeaderModel(title: "Units", rows: rows)
            headerModelList.append(headerModel)
        }

        return headerModelList
    }
}

extension SettingsViewModel {

    struct HeaderModel {

        var title: String

        var rows: [RowModel]
    }

    struct RowModel {

        var title: String
        var value: String
        var unitType: UnitType
    }
}
