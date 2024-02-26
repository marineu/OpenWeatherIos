//
//  StringUtils.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 03/07/2021.
//

import Foundation

public class StringUtils {

    public func searchText(_ text: String, in string: String) -> Bool {
        let words = text.components(separatedBy: " ")
        let ranges = rangesOfFoundText(text, in: string)

        return ranges.count == words.count
    }

    public func rangesOfFoundText(_ text: String, in string: String) -> [Range<String.Index>] {
        let locale = Locale(identifier: "en_US")
        let words = text.components(separatedBy: " ")
        var ranges: [Range<String.Index>] = []

        var nextRange: Range<String.Index>?
        for word in words {
            let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
            guard
                let range = string.range(
                    of: word,
                    options: options,
                    range: nextRange,
                    locale: locale) else
            {
                break
            }

            ranges.append(range)

            nextRange = range.upperBound..<string.endIndex
        }

        guard ranges.count == words.count else {
            return []
        }

        return ranges
    }
}
