//
//  UIImage+Ext.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 12/09/2021.
//

import UIKit

extension UIImage {

    static public func drawMoonPhase(
        _ moonPhase: Double,
        radius: CGFloat,
        lineWidth: CGFloat,
        lightColor: UIColor = .white,
        darkColor: UIColor = .black
    ) -> UIImage? {
        let size = CGSize(width: radius * 2.0, height: radius * 2.0)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)

        let smallRadius = radius - lineWidth

        guard
            let lightShapePath = lightShapePath(moonPhase: moonPhase, center: center, radius: smallRadius)
        else {
            return nil
        }

        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let darkShapePath = darkShapePath(center: center, radius: radius)

        context.saveGState()

        context.addPath(darkShapePath.cgPath)
        darkColor.setFill()
        context.fillPath()

        context.restoreGState()

        context.saveGState()

        context.addPath(lightShapePath.cgPath)
        lightColor.setFill()
        context.fillPath()

        context.restoreGState()

        let image = UIGraphicsGetImageFromCurrentImageContext()

        return image
    }

    static private func darkShapePath(
        center: CGPoint,
        radius: CGFloat
    ) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )

        return path
    }

    static private func lightShapePath(
        moonPhase: Double,
        center: CGPoint,
        radius: CGFloat
    ) -> UIBezierPath? {
        let step = 0.25
        let (integer, reminder) = modf(moonPhase / step)

        let ratio = getRatio(moonPhase: moonPhase, step: step)
        let angle: CGFloat = .pi / 2 * CGFloat(ratio)

        if reminder == 0 {
            let path = mainArcPath(phaseIndex: Int(integer), center: center, radius: radius)
            path?.close()
            return path
        }

        return innerArcPath(phaseIndex: Int(integer), center: center, radius: radius, angle: angle)
    }

    static private func mainArcPath(phaseIndex: Int, center: CGPoint, radius: CGFloat) -> UIBezierPath? {
        switch phaseIndex {
        case 1:
            return arcPath(
                center: center,
                radius: radius,
                startAngle: -.pi / 2,
                endAngle: .pi / 2,
                clockwise: true
            )
        case 2:
            return arcPath(
                center: center,
                radius: radius,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true
            )
        case 3:
            return arcPath(
                center: center,
                radius: radius,
                startAngle: -.pi / 2,
                endAngle: .pi / 2,
                clockwise: false
            )
        default:
            return nil
        }
    }

    static private func innerArcPath(
        phaseIndex: Int,
        center: CGPoint,
        radius: CGFloat,
        angle: CGFloat
    ) -> UIBezierPath? {
        var clockwise = true, innerClockwise = true
        var innerCenter: CGPoint = .zero
        var innerStartAngle: CGFloat = 0, innerEndAngle: CGFloat = 0
        let innerRadius: CGFloat = radius / cos(angle)

        switch phaseIndex {
        case 0:
            clockwise = true
            innerClockwise = false
            innerCenter = CGPoint(x: center.x - radius * tan(angle), y: center.y)
            innerStartAngle = .pi / 2 - angle
            innerEndAngle   = angle - .pi / 2
        case 1:
            clockwise = true
            innerClockwise = true
            innerCenter = CGPoint(x: center.x + radius * tan(angle), y: center.y)
            innerStartAngle = .pi / 2 + angle
            innerEndAngle   = -.pi / 2 - angle
        case 2:
            clockwise = false
            innerClockwise = false
            innerCenter = CGPoint(x: center.x - radius * tan(angle), y: center.y)
            innerStartAngle = .pi / 2 - angle
            innerEndAngle   = -.pi / 2 + angle
        case 3:
            clockwise = false
            innerClockwise = true
            innerCenter = CGPoint(x: center.x + radius * tan(angle), y: center.y)
            innerStartAngle = .pi / 2 + angle
            innerEndAngle   = -.pi / 2 - angle
        default:
            return nil
        }

        let path = UIBezierPath()

        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: .pi / 2,
            clockwise: clockwise
        )

        path.addArc(
            withCenter: innerCenter,
            radius: innerRadius,
            startAngle: innerStartAngle,
            endAngle: innerEndAngle,
            clockwise: innerClockwise
        )

        return path
    }

    static private func arcPath(
        center: CGPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        clockwise: Bool
    ) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArc(
            withCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )

        return path
    }

    static private func getRatio(moonPhase: Double, step: Double) -> Double {
        let (integer, reminder) = modf(moonPhase / step)

        if reminder == 0 {
            return Double(Int(integer) % 2)
        } else {
            switch integer {
            case 1, 3:
                return 1 - (moonPhase - (step * integer)) / step
            default:
                return (moonPhase - (step * integer)) / step
            }
        }
    }
}
