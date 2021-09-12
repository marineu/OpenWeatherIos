//
//  DailyForecastHeader.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 10/09/2021.
//

import UIKit

class DailyForecastHeader: UITableViewHeaderFooterView {

    var settings = Settings() {
        didSet {
            updateUI()
        }
    }

    var headerModel: DailyForecastViewModel.HeaderModel? {
        didSet {
            updateUI()
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            updateUI()
        }
    }

    var didTapToggleButtonHandler: (() -> Void)?

    private let contentViewInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let weatherIconImageViewWidth: CGFloat = 30
    private let separatorViewHeight: CGFloat = 0.5

    // MARK: - subviews declaration

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)

        return label
    }()

    private let weatherIconImageView = UIImageView()

    private let arrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        let imageName = "expand-arrow-icon"
        imageView.image = UIImage(named: imageName)

        return imageView
    }()

    lazy private var leftStackView: UIStackView = {
        let arrangedSubviews = [dateLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal

        return stackView
    }()

    lazy private var rightStackView: UIStackView = {
        let arrangedSubviews = [temperatureLabel, weatherIconImageView, arrowIconImageView]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center

        return stackView
    }()

    private let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.29)

        return view
    }()

    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.29)

        return view
    }()

    lazy private var toggleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapToggleButton), for: .touchUpInside)

        return button
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white

        self.backgroundView = backgroundView
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        didTapToggleButtonHandler = nil
    }

    // MARK: - setup UI

    private func setup() {
        contentView.addSubview(leftStackView)
        contentView.addSubview(rightStackView)
        contentView.addSubview(topSeparatorView)
        contentView.addSubview(bottomSeparatorView)
        contentView.addSubview(toggleButton)

        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: separatorViewHeight).isActive = true

        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bottomSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: separatorViewHeight).isActive = true

        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentViewInset.top
        ).isActive = true

        leftStackView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: contentViewInset.left
        ).isActive = true

        let lsvBottomAnchor = leftStackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentViewInset.bottom
        )
        lsvBottomAnchor.isActive = true
        lsvBottomAnchor.priority = UILayoutPriority(999)

        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentViewInset.top
        ).isActive = true

        rightStackView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -contentViewInset.right
        ).isActive = true

        let rsvBottomAnchor = rightStackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentViewInset.bottom
        )
        rsvBottomAnchor.priority = UILayoutPriority(999)
        rsvBottomAnchor.isActive = true

        weatherIconImageView
            .widthAnchor
            .constraint(equalToConstant: weatherIconImageViewWidth).isActive = true
        weatherIconImageView
            .heightAnchor
            .constraint(equalTo: weatherIconImageView.widthAnchor).isActive = true

        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        toggleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        toggleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        toggleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func updateUI() {
        guard let headerModel = headerModel else {
            return
        }

        let weather = headerModel.weather
        let weatherUtils = WeatherUtils(isNight: weather.isNight)
        let dateUtils = DateUtils()

        dateLabel
            .text = dateUtils.string(from: headerModel.cdt, withFormat: "E MMM dd", timeZone: timeZone)

        let stringMaxTemperature = weatherUtils
            .humanReadableTemperature(
                value: headerModel.maxTemperature,
                by: settings.temperatureUnit,
                showUnit: false
            )
        let stringMinTemperature = weatherUtils
            .humanReadableTemperature(
                value: headerModel.minTemperature,
                by: settings.temperatureUnit,
                showUnit: false
            )

        temperatureLabel.text = "\(stringMaxTemperature) / \(stringMinTemperature)"

        let imageName = weatherUtils.weatherIcon(by: weather.id)
        weatherIconImageView.image = UIImage(named: imageName)

        arrowIconImageView
            .transform = CGAffineTransform(rotationAngle: headerModel.isExpanded ? .pi : .zero)
    }

    // MARK: - actions

    @objc private func didTapToggleButton() {
        didTapToggleButtonHandler?()
    }
}
