//
//  DayShapeView+Ext.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 03/09/2021.
//

import UIKit

// MARK: - draw methods

extension DayShapeView {

    public func drawFirstNightPhase(in rect: CGRect, context: CGContext) {
        guard isInSameDay else {
            return
        }

        let startOfDayTime = startOfDay.timeIntervalSince1970
        let sunriseTime = sunrise.timeIntervalSince1970
        let currentTime = current.timeIntervalSince1970

        let firstNightLength = sunriseTime - startOfDayTime
        let currentLength = currentTime - startOfDayTime

        let percentage = currentLength < firstNightLength ? currentLength / firstNightLength : 1.0
        guard percentage >= 0 else {
            return
        }

        let point = xPoint(in: shapeRect, withY: 0.0)
        let endX = Double(point.x) * percentage
        let transform = CGAffineTransform(translationX: 0, y: CGFloat(offset))

        let path = UIBezierPath(cgPath: shapePath(in: shapeRect, startX: 0.0, endX: endX))
        path.apply(transform)
        path.close()

        context.saveGState()

        context.addPath(path.cgPath)

        nightColor?.setFill()
        context.fillPath()

        context.restoreGState()
    }

    public func drawDaylightPhase(in rect: CGRect, context: CGContext) {
        guard isInSameDay else {
            return
        }

        let sunriseTime = sunrise.timeIntervalSince1970
        let sunsetTime  = sunset.timeIntervalSince1970
        let currentTime = current.timeIntervalSince1970

        let dayLength = sunsetTime - sunriseTime
        let currentLength = currentTime - sunriseTime

        let percentage = currentLength < dayLength ? currentLength / dayLength : 1.0
        guard percentage >= 0 else {
            return
        }

        let insetedRect = rect.inset(by: inset)

        let point = xPoint(in: insetedRect, withY: 0.0)
        let startX = Double(point.x)
        let endX = startX + Double(insetedRect.width - point.x * 2) * percentage
        let transform = CGAffineTransform(translationX: 0, y: CGFloat(offset))

        let path = UIBezierPath(cgPath: shapePath(in: insetedRect, startX: startX, endX: endX))
        path.apply(transform)
        path.close()

        context.saveGState()

        context.addPath(path.cgPath)

        daylightColor?.setFill()
        context.fillPath()

        context.restoreGState()
    }

    public func drawSecondNightPhase(in rect: CGRect, context: CGContext) {
        guard isInSameDay else {
            return
        }

        let endOfDayTime = endOfDay.timeIntervalSince1970
        let sunsetTime = sunset.timeIntervalSince1970
        let currentTime = current.timeIntervalSince1970

        let secondNightLength = endOfDayTime - sunsetTime
        let currentLength = currentTime - sunsetTime

        let percentage = currentLength < secondNightLength ? currentLength / secondNightLength : 1.0
        guard percentage >= 0 else {
            return
        }

        let point = xPoint(in: shapeRect, withY: 0.0)
        let startX = Double(rect.width - point.x)
        let endX = startX + Double(point.x) * percentage
        let transform = CGAffineTransform(translationX: 0, y: CGFloat(offset))

        let path = UIBezierPath(cgPath: shapePath(in: shapeRect, startX: startX, endX: endX))
        path.apply(transform)
        path.close()

        context.saveGState()

        context.addPath(path.cgPath)

        nightColor?.setFill()
        context.fillPath()

        context.restoreGState()
    }

    public func drawSunMovePath(in rect: CGRect, context: CGContext) {
        let path = UIBezierPath(cgPath: sunMovePath(in: shapeRect))

        context.addPath(path.cgPath)
        context.setLineWidth(strokeWidth)

        context.saveGState()

        strokeColor?.setStroke()
        context.strokePath()

        context.restoreGState()
    }

    public func drawHorizonLine(in rect: CGRect, context: CGContext) {
        let translationY = CGFloat(offset)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: shapeRect.midY))
        path.addLine(to: CGPoint(x: shapeRect.maxX, y: shapeRect.midY))
        path.apply(CGAffineTransform(translationX: 0, y: translationY))

        context.addPath(path.cgPath)
        context.setLineWidth(strokeWidth)

        context.saveGState()

        strokeColor?.setStroke()
        context.strokePath()

        context.restoreGState()
    }

    public func drawSunsetSunriseIndicators(in rect: CGRect, context: CGContext) {
        let endLineY = shapeRect.midY + CGFloat(offset) - 5

        let firstPointX = xPoint(in: shapeRect, withY: 0.0).x
        let secondPointX = rect.width - firstPointX

        let path = UIBezierPath()

        path.move(to: CGPoint(x: firstPointX, y: shapeRect.minY))
        path.addLine(to: CGPoint(x: firstPointX, y: endLineY))

        path.move(to: CGPoint(x: secondPointX, y: shapeRect.minY))
        path.addLine(to: CGPoint(x: secondPointX, y: endLineY))

        context.saveGState()

        context.addPath(path.cgPath)
        context.setLineWidth(indicatorsWidth)

        strokeColor?.setStroke()
        context.strokePath()

        context.restoreGState()
    }

    public func drawSun(in rect: CGRect, context: CGContext) {
        let sunriseTime = sunrise.timeIntervalSince1970
        let sunsetTime  = sunset.timeIntervalSince1970
        let currentTime = current.timeIntervalSince1970

        let dayLength = sunsetTime - sunriseTime
        let currentLength = currentTime - sunriseTime

        let percentage = currentLength < dayLength ? currentLength / dayLength : 1.0
        guard percentage >= 0 && percentage < 1 else {
            return
        }

        let point = xPoint(in: shapeRect, withY: 0.0)
        let sunX = Double(point.x) + Double(rect.width - point.x * 2) * percentage
        let sunPoint = yPoint(in: shapeRect, withX: sunX)

        let translationY = CGFloat(offset)
        let transform = CGAffineTransform(translationX: 0, y: translationY)

        let clipRect = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: shapeRect.width,
            height: shapeRect.midY + CGFloat(offset)
        )

        let clipPath = UIBezierPath(rect: clipRect)

        context.saveGState()

        context.addPath(clipPath.cgPath)
        context.clip()

        let sunPath = UIBezierPath(
            arcCenter: sunPoint,
            radius: sunRadius,
            startAngle: 0.0,
            endAngle: 2.0 * .pi,
            clockwise: true
        )
        sunPath.apply(transform)

        context.addPath(sunPath.cgPath)

        sunColor?.setFill()
        context.fillPath()

        context.restoreGState()
    }
}

// MARK: - points and paths calculation methods

extension DayShapeView {

    public func sunMovePath(in rect: CGRect) -> CGPath {
        let path = CGMutablePath()

        let width = Double(rect.width)

        let transform = CGAffineTransform(translationX: 0, y: CGFloat(offset))

        let point = yPoint(in: rect, withX: 0)
        path.move(to: point, transform: transform)

        for x in stride(from: 0, through: width, by: 1) {
            let point = yPoint(in: rect, withX: x)
            path.addLine(to: point, transform: transform)
        }

        return path
    }

    public func shapePath(in rect: CGRect, startX: Double, endX: Double) -> CGPath {
        let path = CGMutablePath()

        let midHeight = Double(rect.midY)

        let ceilStartX = ceil(startX)

        if startX == 0.0 {
            path.move(to: CGPoint(x: 0, y: midHeight))
        } else {
            let diff = ceilStartX - startX
            let point = yPoint(in: rect, withX: startX)
            path.move(to: point)

            if diff != 0 {
                let point = yPoint(in: rect, withX: ceilStartX)
                path.addLine(to: point)
            }
        }

        for x in stride(from: ceilStartX, through: endX, by: 1) {
            let point = yPoint(in: rect, withX: x)
            path.addLine(to: point)
        }

        if endX.truncatingRemainder(dividingBy: 1) > 0 {
            let point = yPoint(in: rect, withX: endX)
            path.addLine(to: point)
        }

        path.addLine(to: CGPoint(x: endX, y: midHeight))

        return path
    }

    public func yPoint(in rect: CGRect, withX x: Double) -> CGPoint {
        let width = Double(rect.width)
        let midHeight = Double(rect.midY)

        let waveLength = width / frequency
        let relativeX = x / waveLength
        let sine = sin(relativeX + phase)
        let y = strength * sine + midHeight - offset

        return CGPoint(x: x, y: y)
    }

    public func xPoint(in rect: CGRect, withY y: Double) -> CGPoint {
        let width = Double(rect.width)
        let midHeight = Double(rect.midY)

        let waveLength = width / frequency
        let arcsine = .pi - asin((y + offset) / strength) - phase
        let x = arcsine * waveLength

        return CGPoint(x: x, y: midHeight + y)
    }
}
