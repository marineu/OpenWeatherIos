//
//  DailyForecastValueCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 10/09/2021.
//

import UIKit

class DailyForecastValueCell: UITableViewCell {

    var settings = Settings() {
        didSet {
            updateUI()
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            updateUI()
        }
    }

    var rowModel: DailyForecastViewModel.RowModel? {
        didSet {
            updateUI()
        }
    }

    private let contentViewInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

    // MARK: - subviews declaration

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    lazy private var stackView: UIStackView = {
        let arrangedSubviews = [valueLabel, windDirectionImageView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 8

        return stackView
    }()

    private let windDirectionImageView = UIImageView(image: UIImage(named: "wind-direction-icon"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        rowModel = nil
    }

    // MARK: - setup UI

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentViewInset.top
        ).isActive = true

        titleLabel.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: contentViewInset.left
        ).isActive = true

        titleLabel.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentViewInset.bottom
        ).isActive = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentViewInset.top
        ).isActive = true

        stackView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -contentViewInset.right
        ).isActive = true

        stackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentViewInset.bottom
        ).isActive = true

        windDirectionImageView.tintColor = .black
    }

    private func updateUI() {
        guard let rowModel = rowModel else { return }

        let weatherUtils = WeatherUtils()
        let dateUtils = DateUtils()

        windDirectionImageView.isHidden = true
        titleLabel.text = title(by: rowModel.rowType)

        switch rowModel.rowType {
        case .precipitation:
            guard let precipitation = rowModel.value as? Double else {
                return
            }

            valueLabel.text = "\(precipitation) mm"
        case .wind:
            guard let (windSpeed, windDeg) = rowModel.value as? (WindSpeed, Double) else {
                return
            }
            let angle = CGFloat(windDeg) * .pi / 180
            windDirectionImageView.transform = CGAffineTransform(rotationAngle: angle)
            windDirectionImageView.isHidden = false

            let stringWindSpeed = weatherUtils
                .humanReadableWindSpeed(value: windSpeed, by: settings.speedUnit)
            let windDirection = weatherUtils.windDirectionShort(by: windDeg)

            valueLabel.text = "\(stringWindSpeed) \(windDirection)"
        case .pressure:
            guard let pressure = rowModel.value as? Pressure else {
                return
            }

            valueLabel.text = weatherUtils
                .humanReadablePressure(value: pressure, by: settings.pressureUnit)
        case .humidity:
            guard let humidity = rowModel.value as? Int8 else {
                return
            }

            valueLabel.text = "\(humidity)%"
        case .uvi:
            guard let uvi = rowModel.value as? Double else {
                return
            }

            valueLabel.text = "\(uvi)"
        case .pop:
            guard let pop = rowModel.value as? Double else {
                return
            }

            valueLabel.text = "\(pop)%"
        case .sunrise:
            guard let sunrise = rowModel.value as? TimeInterval else {
                return
            }

            valueLabel.text = dateUtils.string(from: sunrise, withFormat: "HH:mm", timeZone: timeZone)
        case .sunset:
            guard let sunset = rowModel.value as? TimeInterval else {
                return
            }

            valueLabel.text = dateUtils.string(from: sunset, withFormat: "HH:mm", timeZone: timeZone)
        case .moonrise:
            guard let moonrise = rowModel.value as? TimeInterval else {
                return
            }

            valueLabel.text = dateUtils.string(from: moonrise, withFormat: "HH:mm", timeZone: timeZone)
        case .moonset:
            guard let moonset = rowModel.value as? TimeInterval else {
                return
            }

            valueLabel.text = dateUtils.string(from: moonset, withFormat: "HH:mm", timeZone: timeZone)
        case .moonPhase:
            guard let moonPhase = rowModel.value as? TimeInterval else {
                return
            }

            windDirectionImageView.transform = CGAffineTransform.identity
            windDirectionImageView.isHidden = false
            windDirectionImageView.image = UIImage.drawMoonPhase(moonPhase, radius: 10, lineWidth: 1)

            valueLabel.text = weatherUtils.moonPhaseDescription(by: moonPhase)
        }
    }

    private func title(by rowType: DailyForecastViewModel.RowType) -> String {
        switch rowType {
        case .precipitation:
            return "Precipitation"
        case .wind:
            return "Wind"
        case .pressure:
            return "Pressure"
        case .humidity:
            return "Humidity"
        case .uvi:
            return "UV Index"
        case .pop:
            return "Probability of precipitation"
        case .sunrise:
            return "Sunrise"
        case .sunset:
            return "Sunset"
        case .moonrise:
            return "Moonrise"
        case .moonset:
            return "Moonset"
        case .moonPhase:
            return "Moon phase"
        }
    }
}
