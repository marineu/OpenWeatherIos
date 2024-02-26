//
//  DailyForecastViewModel.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 09/09/2021.
//

import Foundation

public class DailyForecastViewModel: BaseViewModel {

    var headerModelList: [HeaderModel] = []
    private(set) var dailyForecastsCount: Int
    private(set) var timeZone: TimeZone
    private(set) var appDataManager: AppDataManager

    init(appDataManager: AppDataManager, dailyForecasts: [DailyForecast], timeZone: TimeZone) {
        self.appDataManager = appDataManager
        dailyForecastsCount = dailyForecasts.count
        self.timeZone = timeZone
        super.init()

        self.headerModelList = initializeTableViewData(dailyForecasts)
    }

    public func setIsExpanded(_ isExpanded: Bool, at index: Int) {
        headerModelList[index].isExpanded = isExpanded
    }

    private func initializeTableViewData(_ dailyForecasts: [DailyForecast]) -> [HeaderModel] {
        var headerModelList: [HeaderModel] = []

        for index in 0..<dailyForecasts.count {
            let dailyForecast = dailyForecasts[index]

            guard let firstWeather = dailyForecast.weather.first else {
                continue
            }

            var rowModelList: [RowModel] = []
            for rowType in RowType.allCases {
                var row = RowModel(value: 0, rowType: .precipitation)

                switch rowType {
                case .precipitation:
                    let precipitation = dailyForecast.rain ?? dailyForecast.snow ?? 0
                    row = RowModel(value: precipitation, rowType: rowType)
                case .wind:
                    row = RowModel(
                        value: (dailyForecast.windSpeed, dailyForecast.windDeg),
                        rowType: rowType)
                case .pressure:
                    row = RowModel(value: dailyForecast.pressure, rowType: rowType)
                case .humidity:
                    row = RowModel(value: dailyForecast.humidity, rowType: rowType)
                case .uvi:
                    row = RowModel(value: dailyForecast.uvi, rowType: rowType)
                case .pop:
                    row = RowModel(value: dailyForecast.pop, rowType: rowType)
                case .sunrise:
                    row = RowModel(value: dailyForecast.sunrise, rowType: rowType)
                case .sunset:
                    row = RowModel(value: dailyForecast.sunset, rowType: rowType)
                case .moonrise:
                    row = RowModel(value: dailyForecast.moonrise, rowType: rowType)
                case .moonset:
                    row = RowModel(value: dailyForecast.moonset, rowType: rowType)
                case .moonPhase:
                    row = RowModel(value: dailyForecast.moonPhase, rowType: rowType)
                }

                rowModelList.append(row)
            }

            let headerModel = HeaderModel(
                isExpanded: false,
                cdt: dailyForecast.cdt,
                minTemperature: dailyForecast.dailyTemperature.min,
                maxTemperature: dailyForecast.dailyTemperature.max,
                weather: firstWeather,
                rowModelList: rowModelList
            )

            headerModelList.append(headerModel)
        }

        return headerModelList
    }
}

extension DailyForecastViewModel {

    struct HeaderModel {

        var isExpanded: Bool

        var cdt: TimeInterval
        var minTemperature: Temperature?
        var maxTemperature: Temperature?
        var weather: WeatherDetails

        var rowModelList: [RowModel]
    }

    struct RowModel {

        var value: Any

        var rowType: RowType
    }

    enum RowType: Int, CaseIterable {

        case precipitation
        case wind
        case pressure
        case humidity
        case uvi
        case pop
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase
    }
}
