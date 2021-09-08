//
//  DayShapeView.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 03/09/2021.
//

import UIKit

class DayShapeView: UIView {

    var nightColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    var daylightColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    var sunColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    var strokeColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    var strokeWidth: CGFloat = 1 {
        didSet {
            setNeedsDisplay()
        }
    }

    var indicatorsWidth: CGFloat = 0.33 {
        didSet {
            setNeedsDisplay()
        }
    }

    var sunRadius: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    var sunrise: Date {
        didSet {
            setNeedsDisplay()
        }
    }

    var sunset: Date {
        didSet {
            setNeedsDisplay()
        }
    }

    var current: Date {
        didSet {
            setNeedsDisplay()
        }
    }

    var nightPhaseLength: CGFloat {
        return xPoint(in: shapeRect, withY: 0.0).x
    }

    var timeZone: TimeZone = .current {
        didSet {
            setNeedsDisplay()
        }
    }

    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = timeZone

        return calendar
    }

    var startOfDay: Date {
        return calendar.startOfDay(for: current)
    }

    var endOfDay: Date {
        return startOfDay.addingTimeInterval(86340)
    }

    var isInSameDay: Bool {
        let sunsetIsInSameDay = calendar.isDate(current, inSameDayAs: sunset)
        let sunriseIsInSameDay = calendar.isDate(current, inSameDayAs: sunrise)

        return sunsetIsInSameDay && sunriseIsInSameDay
    }

    var strength: Double {
        return Double(shapeRect.height) * 0.5
    }

    let frequency: Double = .pi * 2
    let phase: Double     = .pi / 2

    var offset: Double {
        return Double(shapeRect.height) * 0.18
    }

    var shapeRect: CGRect {
        return bounds.inset(by: inset)
    }

    lazy private(set) var inset: UIEdgeInsets = {
        return UIEdgeInsets(top: sunRadius, left: 0, bottom: 0, right: 0)
    }()

    init(sunrise: Date, sunset: Date, current: Date) {
        self.sunrise = sunrise
        self.sunset = sunset
        self.current = current
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        drawFirstNightPhase(in: rect, context: context)
        drawDaylightPhase(in: rect, context: context)
        drawSecondNightPhase(in: rect, context: context)
        drawSunMovePath(in: rect, context: context)
        drawHorizonLine(in: rect, context: context)
        drawSunsetSunriseIndicators(in: rect, context: context)
        drawSun(in: rect, context: context)
    }
}
