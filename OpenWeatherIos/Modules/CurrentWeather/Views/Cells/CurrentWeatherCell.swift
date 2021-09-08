//
//  CurrentWeatherCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 18/08/2021.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {

    var settings = Settings() {
        didSet {
            updateUI()
        }
    }

    var currentWeather: CurrentWeather? {
        didSet {
            updateUI()
        }
    }

    private let mainStackViewInset = UIEdgeInsets(top: 20, left: 16, bottom: 8, right: 16)
    private let imageWidth: CGFloat = 45

    // MARK: - subviews declaration

    lazy private var mainStackView: UIStackView = {
        let arrangedSubviews = [
            secondStackView, temperatureLabel, feelsLikeLabel
        ]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center

        return stackView
    }()

    lazy private var secondStackView: UIStackView = {
        let arrangedSubviews = [weatherIconImageView, thirdStackView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.alignment = .center

        return stackView
    }()

    lazy private var thirdStackView: UIStackView = {
        let arrangedSubviews = [cloudDescriptionLabel, windDescriptionLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    private let cloudDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private let windDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 1.0, alpha: 0.7)
        label.font = .systemFont(ofSize: 13)

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 60)

        return label
    }()

    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textColor = .init(white: 1.0, alpha: 0.7)
        label.font = .systemFont(ofSize: 13)

        return label
    }()

    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearUI()
    }

    // MARK: - setup UI

    private func setup() {
        // setup mainStackView constraints

        contentView.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: mainStackViewInset.top).isActive = true
        mainStackView.leadingAnchor.constraint(
            greaterThanOrEqualTo: contentView.leadingAnchor,
            constant: mainStackViewInset.left).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        contentView.bottomAnchor.constraint(
            equalTo: mainStackView.bottomAnchor,
            constant: mainStackViewInset.bottom).isActive = true
        contentView.trailingAnchor.constraint(
            greaterThanOrEqualTo: mainStackView.trailingAnchor,
            constant: mainStackViewInset.right).isActive = true

        weatherIconImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        weatherIconImageView.heightAnchor
            .constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true
    }

    private func updateUI() {
        guard
            let currentWeather = currentWeather,
            let weather = currentWeather.weather.first
        else {
            return
        }

        let weatherUtils = WeatherUtils(isNight: weather.isNight)

        cloudDescriptionLabel.text = weather.description.capitalized
        windDescriptionLabel.text  = weatherUtils.windSpeedDescription(by: currentWeather.windSpeed)

        let imageName = weatherUtils.weatherIcon(by: weather.id)
        weatherIconImageView.image = UIImage(named: imageName)

        temperatureLabel.text = weatherUtils.humanReadableTemperature(
            value: currentWeather.temperature,
            by: settings.temperatureUnit)

        let feelsLikeLabelText = weatherUtils.humanReadableTemperature(
            value: currentWeather.temperature,
            by: settings.temperatureUnit)
        feelsLikeLabel.text = "Feels like \(feelsLikeLabelText)"
    }

    private func clearUI() {
        cloudDescriptionLabel.text = ""
        windDescriptionLabel.text  = ""
        weatherIconImageView.image = nil
        temperatureLabel.text      = ""
        feelsLikeLabel.text        = ""
    }
}
