//
//  SunsetView.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 03/09/2021.
//

import UIKit

class SunsetView: UIView {

    private(set) var dayShapeView: DayShapeView

    var sunrise: Date {
        get {
            return dayShapeView.sunrise
        }

        set {
            dayShapeView.sunrise = newValue
        }
    }

    var sunset: Date {
        get {
            return dayShapeView.sunset
        }

        set {
            dayShapeView.sunset = newValue
        }
    }

    var current: Date {
        get {
            return dayShapeView.current
        }

        set {
            dayShapeView.current = newValue
        }
    }

    var firstLabelsFont: UIFont? = .systemFont(ofSize: 13) {
        didSet {
            sunriseLabel.font = firstLabelsFont
            sunsetLabel.font  = firstLabelsFont
        }
    }

    var firstLabelsColor: UIColor? {
        didSet {
            sunriseLabel.textColor = firstLabelsColor
            sunsetLabel.textColor  = firstLabelsColor
        }
    }

    var secondLabelsFont: UIFont? = .systemFont(ofSize: 17) {
        didSet {
            sunriseTimeLabel.font = secondLabelsFont
            sunsetTimeLabel.font  = secondLabelsFont
        }
    }

    var secondLabelsColor: UIColor? {
        didSet {
            sunriseTimeLabel.textColor = secondLabelsColor
            sunsetTimeLabel.textColor  = secondLabelsColor
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            dayShapeView.timeZone = timeZone
            sunriseTimeLabel.text = formattingTime(from: sunrise)
            sunsetTimeLabel.text = formattingTime(from: sunset)
        }
    }

    private let dayShapeRatio: CGFloat = 0.23

    lazy private(set) var sunriseLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunrise"
        label.font = firstLabelsFont
        label.textColor = firstLabelsColor

        return label
    }()

    lazy private(set) var sunsetLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunset"
        label.font = firstLabelsFont
        label.textColor = firstLabelsColor

        return label
    }()

    lazy private(set) var sunriseTimeLabel: UILabel = {
        let label = UILabel()
        label.text = formattingTime(from: sunrise)
        label.font = secondLabelsFont
        label.textColor = secondLabelsColor

        return label
    }()

    lazy private(set) var sunsetTimeLabel: UILabel = {
        let label = UILabel()
        label.text = formattingTime(from: sunset)
        label.font = secondLabelsFont
        label.textColor = secondLabelsColor

        return label
    }()

    lazy private var sunriseStackView: UIStackView = {
        let arrangedSubviews = [sunriseLabel, sunriseTimeLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center

        return stackView
    }()

    lazy private var sunsetStackView: UIStackView = {
        let arrangedSubviews = [sunsetLabel, sunsetTimeLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center

        return stackView
    }()

    private var sunriseStackViewTrailing: NSLayoutConstraint?
    private var sunsetStackViewLeading: NSLayoutConstraint?

    init(sunrise: Date, sunset: Date, current: Date) {
        dayShapeView = DayShapeView(sunrise: sunrise, sunset: sunset, current: current)
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let nightPhaseLength = dayShapeView.nightPhaseLength

        sunriseStackViewTrailing?.constant = nightPhaseLength
        sunsetStackViewLeading?.constant   = -nightPhaseLength
    }

    // MARK: - setup UI

    private func setup() {
        addSubview(sunriseStackView)
        addSubview(sunsetStackView)
        addSubview(dayShapeView)

        sunriseStackView.translatesAutoresizingMaskIntoConstraints = false
        sunriseStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sunriseStackViewTrailing = sunriseStackView.trailingAnchor.constraint(equalTo: leadingAnchor)
        sunriseStackViewTrailing?.isActive = true

        sunsetStackView.translatesAutoresizingMaskIntoConstraints = false
        sunsetStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sunsetStackViewLeading = sunsetStackView.leadingAnchor.constraint(equalTo: trailingAnchor)
        sunsetStackViewLeading?.isActive = true

        dayShapeView.translatesAutoresizingMaskIntoConstraints = false
        dayShapeView.topAnchor.constraint(equalTo: sunsetStackView.bottomAnchor).isActive = true
        dayShapeView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: dayShapeView.trailingAnchor).isActive = true
        dayShapeView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dayShapeView
            .heightAnchor
            .constraint(equalTo: dayShapeView.widthAnchor, multiplier: dayShapeRatio, constant: 10)
            .isActive = true
    }

    // MARK: - private methods

    private func formattingTime(from date: Date) -> String? {
        let dateUtils = DateUtils()
        return dateUtils.string(from: date.timeIntervalSince1970, withFormat: "HH:mm", timeZone: timeZone)
    }
}
