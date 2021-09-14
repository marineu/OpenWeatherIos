//
//  LocationWeatherCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/09/2021.
//

import UIKit

class LocationWeatherCell: UITableViewCell {

    var settings = Settings() {
        didSet {
            updateUI()
        }
    }

    var cityWeatherForecast: CityWeatherForecast? {
        didSet {
            updateUI()
        }
    }

    private let contentViewInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    private let skyViewInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
    private let cornerRadius: CGFloat = 10

    // MARK: - subviews declaration

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white

        return label
    }()

    private let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white

        return label
    }()

    lazy private var mainStackView: UIStackView = {
        let arrangedSubviews = [leftStackView, temperatureLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        return stackView
    }()

    lazy private var leftStackView: UIStackView = {
        let arrangedSubviews = [titleLabel, minMaxTemperatureLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }()

    lazy private var skyView: SkyView = {
        let skyView = SkyView(skyType: .default)
        skyView.layer.cornerRadius = cornerRadius
        skyView.clipsToBounds = true

        return skyView
    }()

    // MARK: - subviews declaration

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
        clearUI()
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
        contentView.addSubview(skyView)
        skyView.addSubview(mainStackView)

        skyView.translatesAutoresizingMaskIntoConstraints = false
        skyView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentViewInset.top
        ).isActive = true
        skyView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: contentViewInset.left
        ).isActive = true
        skyView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -contentViewInset.right
        ).isActive = true
        let bottomAnchor = skyView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentViewInset.bottom
        )
        bottomAnchor.priority = UILayoutPriority(999)
        bottomAnchor.isActive = true

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(
            equalTo: skyView.topAnchor,
            constant: skyViewInset.top
        ).isActive = true
        mainStackView.leadingAnchor.constraint(
            equalTo: skyView.leadingAnchor,
            constant: skyViewInset.left
        ).isActive = true
        mainStackView.trailingAnchor.constraint(
            equalTo: skyView.trailingAnchor,
            constant: -skyViewInset.right
        ).isActive = true
        mainStackView.bottomAnchor.constraint(
            equalTo: skyView.bottomAnchor,
            constant: -skyViewInset.bottom
        ).isActive = true
    }

    private func updateUI() {
        guard let cityWeatherForecast = cityWeatherForecast else {
            return
        }

        let city = cityWeatherForecast.city
        titleLabel.text = "\(city.name), \(city.country)"

        let oneCallResponse = cityWeatherForecast.oneCallResponse

        guard
            let current = oneCallResponse.current,
            let weather = current.weather.first
        else {
            return
        }

        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: oneCallResponse.timezone) ?? .current

        let dailyForecast = oneCallResponse.daily?.first {
            let date = Date(timeIntervalSince1970: $0.cdt)
            let now = Date()

            return calendar.isDate(date, inSameDayAs: now)
        }

        guard let dailyForecast = dailyForecast else {
            return
        }

        let weatherUtils = WeatherUtils(isNight: weather.isNight)

        let stringMaxTemperature = weatherUtils
            .humanReadableTemperature(
                value: dailyForecast.dailyTemperature.max,
                by: settings.temperatureUnit,
                showUnit: false
            )
        let stringMinTemperature = weatherUtils
            .humanReadableTemperature(
                value: dailyForecast.dailyTemperature.min,
                by: settings.temperatureUnit,
                showUnit: false
            )

        minMaxTemperatureLabel.text = "\(stringMaxTemperature) / \(stringMinTemperature)"
        temperatureLabel.text = weatherUtils.humanReadableTemperature(
            value: current.temperature,
            by: settings.temperatureUnit
        )

        let skyType = weatherUtils.skyType(by: weather.id)
        skyView.skyType = skyType
    }

    private func clearUI() {
        titleLabel.text = " "
        temperatureLabel.text = "--"
        minMaxTemperatureLabel.text = "-- / --"
    }
}
