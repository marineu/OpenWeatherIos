//
//  HourlyForecastItemCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 20/08/2021.
//

import UIKit

class HourlyForecastItemCell: UICollectionViewCell {

    var settings = Settings() {
        didSet {
            updateUI()
        }
    }

    var hourlyForecast: HourlyForecast? {
        didSet {
            updateUI()
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            updateUI()
        }
    }

    private let imageWidth: CGFloat = 25
    private let windDirectionImageWidth: CGFloat = 16

    // MARK: - subviews declaration

    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .init(white: 1.0, alpha: 0.7)

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white

        return label
    }()

    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white

        return label
    }()

    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    private let windDirectionImageView = UIImageView(image: UIImage(named: "wind-direction-icon"))

    lazy private var mainStackView: UIStackView = {
        let arrangedSubviews = [secondStackView, weatherIconImageView, thirdStackView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 5.5
        stackView.alignment = .center

        return stackView
    }()

    lazy private var secondStackView: UIStackView = {
        let arrangedSubviews = [hourLabel, temperatureLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center

        return stackView
    }()

    lazy private var thirdStackView: UIStackView = {
        let arrangedSubviews = [windDirectionImageView, windSpeedLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.alignment = .center

        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true

        contentView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true

        weatherIconImageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        weatherIconImageView.heightAnchor
            .constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true

        windDirectionImageView.widthAnchor
            .constraint(equalToConstant: windDirectionImageWidth).isActive = true
        windDirectionImageView.heightAnchor
            .constraint(equalTo: windDirectionImageView.widthAnchor).isActive = true

        windDirectionImageView.tintColor = .white
    }

    private func updateUI() {
        guard
            let hourlyForecast = hourlyForecast,
            let firstWeather = hourlyForecast.weather.first
        else {
            return
        }

        let weatherUtils = WeatherUtils(isNight: firstWeather.isNight)

        hourLabel.text = formattingTime(with: hourlyForecast.cdt)
        temperatureLabel.text = weatherUtils
            .humanReadableTemperature(
                value: hourlyForecast.temperature,
                by: settings.temperatureUnit,
                showUnit: false
            )

        let imageName = weatherUtils.weatherIcon(by: firstWeather.id)
        weatherIconImageView.image = UIImage(named: imageName)

        windSpeedLabel.text = weatherUtils
            .humanReadableWindSpeed(value: hourlyForecast.windSpeed, by: settings.speedUnit)

        let angle = CGFloat(hourlyForecast.windDeg) * .pi / 180
        windDirectionImageView.transform = CGAffineTransform(rotationAngle: angle)
    }

    private func clearUI() {
        weatherIconImageView.image = nil
        temperatureLabel.text      = " "
        windSpeedLabel.text        = " "
        hourLabel.text             = " "
    }

    // MARK: - formatting data

    private func formattingTime(with timeInterval: TimeInterval) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone

        let dateUtils = DateUtils()
        let date = Date(timeIntervalSince1970: timeInterval)
        let now = Date()

        if calendar.isDate(now, equalTo: date, toGranularity: .hour) {
            return "Now"
        } else {
            if calendar.component(.hour, from: date) == 0 {
                return dateUtils.string(from: timeInterval, withFormat: "M/d", timeZone: timeZone)
            } else {
                return dateUtils.string(from: timeInterval, withFormat: "HH:mm", timeZone: timeZone)
            }
        }
    }
}
