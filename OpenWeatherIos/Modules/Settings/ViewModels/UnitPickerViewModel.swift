//
//  UnitPickerViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import Foundation

public class UnitPickerViewModel: BaseViewModel {

    var inputData: InputData

    init(inputData: InputData) {
        self.inputData = inputData
        super.init()
    }
}

extension UnitPickerViewModel {

    struct InputData {

        var units: [UniversalUnit]
        var selectedUnit: UniversalUnit
        var unitType: UnitType
    }

    struct UniversalUnit {

        var raw: Int = 0
        var description: String = ""
    }
}
