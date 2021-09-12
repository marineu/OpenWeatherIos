//
//  AdditionalWeatherCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 03/09/2021.
//

import UIKit

class AdditionalWeatherCell: UITableViewCell {

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

    private let secondContentViewInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let mainStackViewInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let windDirectionImageWidth: CGFloat = 16
    private let cornerRadius: CGFloat = 10

    // MARK: - subviews declaration

    lazy private var secondContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.backgroundColor = .init(white: 1.0, alpha: 0.3)

        return view
    }()

    lazy private var mainStackView: UIStackView = {
        let arrangedSubviews = [leftStackView, rightStackView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5

        return stackView
    }()

    lazy private var leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
    }()

    lazy private var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16

        return stackView
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

        leftStackView.addArrangedSubview(createValueView(tag: 1, title: "Dew point"))
        leftStackView.addArrangedSubview(createValueView(tag: 2, title: "Visibility"))
        leftStackView.addArrangedSubview(createValueView(tag: 3, title: "Wind"))

        rightStackView.addArrangedSubview(createValueView(tag: 1, title: "Humidity"))
        rightStackView.addArrangedSubview(createValueView(tag: 2, title: "Pressure"))
        rightStackView.addArrangedSubview(createValueView(tag: 3, title: "UV Index"))
    }

    private func updateUI() {
        guard
            let currentWeather = currentWeather,
            let firstWeather = currentWeather.weather.first
        else {
            return
        }

        let weatherUtils = WeatherUtils(isNight: firstWeather.isNight)

        // set dew point
        if let (label, imageView) = getValueLabelAndImageView(in: leftStackView, tag: 1) {
            label.text = weatherUtils
                .humanReadableTemperature(
                    value: currentWeather.dewPoint,
                    by: settings.temperatureUnit
                )
            imageView.isHidden = true
        }

        // set visibility
        if let (label, imageView) = getValueLabelAndImageView(in: leftStackView, tag: 2) {
            label.text = weatherUtils
                .humanReadableLength(
                    value: currentWeather.visibility,
                    by: settings.lengthUnit
                )
            imageView.isHidden = true
        }

        // set wind
        if let (label, imageView) = getValueLabelAndImageView(in: leftStackView, tag: 3) {
            label.text = weatherUtils
                .humanReadableWindSpeed(
                    value: currentWeather.windSpeed,
                    by: settings.speedUnit
                )
            imageView.isHidden = false

            let angle = CGFloat(currentWeather.windDeg) * .pi / 180
            imageView.transform = CGAffineTransform(rotationAngle: angle)
        }

        // set humidity
        if let (label, imageView) = getValueLabelAndImageView(in: rightStackView, tag: 1) {
            label.text = "\(currentWeather.humidity)%"
            imageView.isHidden = true
        }

        // set pressure
        if let (label, imageView) = getValueLabelAndImageView(in: rightStackView, tag: 2) {
            label.text = weatherUtils
                .humanReadablePressure(
                    value: currentWeather.pressure,
                    by: settings.pressureUnit
                )
            imageView.isHidden = true
        }

        // set UV Index
        if let (label, imageView) = getValueLabelAndImageView(in: rightStackView, tag: 3) {
            label.text = "\(currentWeather.uvi)"
            imageView.isHidden = true
        }
    }

    private func createValueView(tag: Int, title: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 13)

        let valueLabel = UILabel()
        valueLabel.text = "frgth"
        valueLabel.tag = 100
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 17)

        let imageName = "wind-direction-icon"
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.tag = 101
        imageView.tintColor = .white

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: windDirectionImageWidth).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true

        let secondStackView = UIStackView(arrangedSubviews: [imageView, valueLabel])
        secondStackView.alignment = .center
        secondStackView.spacing = 3

        let arrangedSubviews = [titleLabel, secondStackView]

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.tag = tag
        stackView.alignment = .leading

        return stackView
    }

    private func getValueLabelAndImageView(in view: UIView, tag: Int) -> (UILabel, UIImageView)? {
        guard
            let subview = view.viewWithTag(tag),
            let label = subview.viewWithTag(100) as? UILabel,
            let imageView = subview.viewWithTag(101) as? UIImageView
        else {
            return nil
        }

        return (label, imageView)
    }
}
