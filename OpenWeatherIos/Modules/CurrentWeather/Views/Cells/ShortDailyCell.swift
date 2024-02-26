//
//  ShortDailyCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 19/08/2021.
//

import UIKit

class ShortDailyCell: UITableViewCell {

    var settings = Settings() {
        didSet {
            updateUI()
        }
    }

    var dailyForecasts: [DailyForecast]? {
        didSet {
            updateUI()
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            updateUI()
        }
    }

    var dailyForecastsCount: Int = 0 {
        didSet {
            button.setTitle("\(dailyForecastsCount)-day forecast", for: .normal)
        }
    }

    var didTapButtonHandler: (() -> Void)?

    private let mainStackViewInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    private let imageWidth: CGFloat = 30

    // MARK: - subviews declaration

    private var stackViews: [UIStackView] = []

    lazy private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    lazy private var button: RoundButton = {
        let button = RoundButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.init(white: 1.0, alpha: 0.7), for: .highlighted)
        button.backgroundColor = .init(white: 1.0, alpha: 0.3)
        button.isCircle = true
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)

        return button
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
        didTapButtonHandler = nil
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
            equalTo: contentView.leadingAnchor,
            constant: mainStackViewInset.left).isActive = true

        contentView.bottomAnchor.constraint(
            equalTo: mainStackView.bottomAnchor,
            constant: mainStackViewInset.bottom).isActive = true
        contentView.trailingAnchor.constraint(
            equalTo: mainStackView.trailingAnchor,
            constant: mainStackViewInset.right).isActive = true
    }

    private func updateUI() {
        stackViews.forEach { $0.removeFromSuperview() }
        stackViews.removeAll()

        guard let dailyForecasts = dailyForecasts else {
            return
        }

        for index in 0..<dailyForecasts.count {
            let stackView = createRowStackView()

            mainStackView.addArrangedSubview(stackView)
            stackViews.append(stackView)

            let dailyForecast = dailyForecasts[index]
            guard let weather = dailyForecast.weather.first else {
                break
            }
            let weatherUtils = WeatherUtils(isNight: weather.isNight)
            let dateUtils    = DateUtils()

            let imageName = weatherUtils.weatherIcon(by: weather.id)
            let imageView = stackView.viewWithTag(100) as? UIImageView
            imageView?.image = UIImage(named: imageName)

            let stringDay = dateUtils.string(from: dailyForecast.cdt, withFormat: "E", timeZone: timeZone)
            let firstLabelText = "\(stringDay) · \(weather.description.capitalized)"

            let firstLabel = stackView.viewWithTag(101) as? UILabel
            firstLabel?.text = firstLabelText

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

            let secondLabel = stackView.viewWithTag(102) as? UILabel
            secondLabel?.text = "\(stringMaxTemperature) / \(stringMinTemperature)"
        }

        if let stackView = stackViews.last {
            mainStackView.setCustomSpacing(15, after: stackView)
            mainStackView.addArrangedSubview(button)
        }
    }

    private func createRowStackView() -> UIStackView {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.heightAnchor
            .constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.tag = 100

        let firstLabel = UILabel()
        firstLabel.textColor = .white
        firstLabel.font = .systemFont(ofSize: 14)
        firstLabel.tag = 101

        let secondLabel = UILabel()
        secondLabel.textColor = .white
        secondLabel.font = .systemFont(ofSize: 14)
        secondLabel.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        secondLabel.tag = 102

        let arrangedSubviews = [imageView, firstLabel, secondLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.spacing = 8

        return stackView
    }

    // MARK: - actions

    @objc private func didTapButton(_ sender: UIButton) {
        didTapButtonHandler?()
    }
}
