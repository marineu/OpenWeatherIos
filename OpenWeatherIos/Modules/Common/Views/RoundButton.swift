//
//  RoundButton.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 19/08/2021.
//

import UIKit

class RoundButton: UIButton {

    var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupCornerRadius()
        }
    }

    var isCircle = false {
        didSet {
            setupCornerRadius()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCornerRadius()
    }

    private func setupCornerRadius() {
        layer.cornerRadius = isCircle ? bounds.midY : cornerRadius
    }
}
