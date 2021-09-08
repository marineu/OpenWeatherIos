//
//  SunsetCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/09/2021.
//

import UIKit

class SunsetCell: UITableViewCell {

    var currentWeather: CurrentWeather? {
        didSet {
            updateUI()
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            updateUI()
        }
    }

    private let secondContentViewInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let mainStackViewInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let cornerRadius: CGFloat = 10

    // MARK: - subviews declaration

    lazy private var secondContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.backgroundColor = .white

        return view
    }()

    lazy private var mainStackView: UIStackView = {
        let arrangedSubviews = [titleLabel, sunsetView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 10

        return stackView
    }()

    private let sunsetView: SunsetView = {
        let now = Date()
        let sunsetView = SunsetView(sunrise: now, sunset: now, current: now)

        sunsetView.dayShapeView.nightColor = .night
        sunsetView.dayShapeView.daylightColor = .daylight
        sunsetView.dayShapeView.sunColor   = .sun
        sunsetView.dayShapeView.strokeColor = .lightGray
        sunsetView.dayShapeView.strokeWidth = 0.5
        sunsetView.dayShapeView.backgroundColor = .white

        sunsetView.firstLabelsColor = .lightGray
        sunsetView.secondLabelsFont = .systemFont(ofSize: 17, weight: .light)

        return sunsetView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunrise & sunset"
        label.font = .systemFont(ofSize: 15)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup UI

    private func setup() {
        contentView.addSubview(secondContentView)
        secondContentView.addSubview(mainStackView)

        secondContentView.translatesAutoresizingMaskIntoConstraints = false
        secondContentView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: secondContentViewInset.top
        ).isActive = true
        secondContentView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: secondContentViewInset.left
        ).isActive = true

        contentView.trailingAnchor.constraint(
            equalTo: secondContentView.trailingAnchor,
            constant: secondContentViewInset.right
        ).isActive = true
        contentView.bottomAnchor.constraint(
            equalTo: secondContentView.bottomAnchor,
            constant: secondContentViewInset.bottom
        ).isActive = true

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(
            equalTo: secondContentView.topAnchor,
            constant: mainStackViewInset.top
        ).isActive = true
        mainStackView.leadingAnchor.constraint(
            equalTo: secondContentView.leadingAnchor,
            constant: mainStackViewInset.left
        ).isActive = true

        secondContentView.trailingAnchor.constraint(
            equalTo: mainStackView.trailingAnchor,
            constant: mainStackViewInset.right
        ).isActive = true
        secondContentView.bottomAnchor.constraint(
            equalTo: mainStackView.bottomAnchor,
            constant: mainStackViewInset.bottom
        ).isActive = true

        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }

    private func updateUI() {
        guard
            let currentWeather = currentWeather
        else {
            return
        }

        sunsetView.sunrise = Date(timeIntervalSince1970: currentWeather.sunrise)
        sunsetView.sunset = Date(timeIntervalSince1970: currentWeather.sunset)
        sunsetView.current = Date(timeIntervalSince1970: currentWeather.cdt)
        sunsetView.timeZone = timeZone
    }
}
