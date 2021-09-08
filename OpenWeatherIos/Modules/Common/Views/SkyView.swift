//
//  SkyView.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 05/08/2021.
//

import UIKit

public class SkyView: UIView {

    var skyType: SkyType {
        didSet {
            setupGradientColors()
        }
    }

    private let firstColorLocation: NSNumber = 0.09
    private var gradientLayer = CAGradientLayer()

    init(skyType: SkyType) {
        self.skyType = skyType
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private func setup() {
        layer.addSublayer(gradientLayer)

        gradientLayer.locations = [firstColorLocation]
        setupGradientColors()
        gradientLayer.type = .axial
    }

    private func setupGradientColors() {
        let colors = getGradientColors(by: skyType)
        gradientLayer.colors = [colors.first.cgColor, colors.second.cgColor]
    }

    private func getGradientColors(by skyType: SkyType) -> (first: UIColor, second: UIColor) {
        switch skyType {
        case .clearNight:
            return (UIColor.clearNightStart, UIColor.clearNightEnd)
        case .cloudyFoggyNight:
            return (UIColor.cloudyFoggyNightStart, UIColor.cloudyFoggyNightEnd)
        case .rainyNight:
            return (UIColor.rainyNightStart, UIColor.rainyNightEnd)
        case .snowyIcyNight:
            return (UIColor.snowyIcyNightStart, UIColor.snowyIcyNightEnd)
        case .sunnyDay:
            return (UIColor.sunnyDayStart, UIColor.sunnyDayEnd)
        case .cloudyFoggyDay:
            return (UIColor.cloudyFoggyDayStart, UIColor.cloudyFoggyDayEnd)
        case .rainyDay:
            return (UIColor.rainyDayStart, UIColor.rainyDayEnd)
        case .snowyIcyDay:
            return (UIColor.snowyIcyDayStart, UIColor.snowyIcyDayEnd)
        case .default:
            return (UIColor.dodgerBlue, UIColor.dodgerBlue)
        }
    }
}
