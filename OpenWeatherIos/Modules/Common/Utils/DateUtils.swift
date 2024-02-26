//
//  DateUtils.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 19/08/2021.
//

import Foundation

public class DateUtils {

    public func string(
        from timeInterval: TimeInterval,
        withFormat format: String,
        timeZone: TimeZone?
    ) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: date)
    }
}
