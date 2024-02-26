//
//  LocationSearchResultCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/09/2021.
//

import UIKit

class LocationSearchResultCell: UITableViewCell {

    var city: City? {
        didSet {
            guard let city = city else {
                return
            }

            titleLabel.text = "\(city.name), \(city.country)"
            coordinateLabel.text = formattingCoordinate(latitude: city.latitude, longitude: city.longitude)
        }
    }

    private let contentViewInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    // MARK: - subviews declaration

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2

        return label
    }()

    private let coordinateLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lightGray

        return label
    }()

    lazy private var stackView: UIStackView = {
        let arrangedSubviews = [titleLabel, coordinateLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8

        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setup UI

    private func setup() {
        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: contentViewInset.top
        ).isActive = true
        stackView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: contentViewInset.left
        ).isActive = true
        stackView.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -contentViewInset.right
        ).isActive = true
        stackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -contentViewInset.bottom
        ).isActive = true
    }

    private func formattingCoordinate(latitude: Double, longitude: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 3

        let latitudeString = numberFormatter.string(from: NSNumber(value: latitude)) ?? ""
        let longitudeString = numberFormatter.string(from: NSNumber(value: longitude)) ?? ""

        return "\(latitudeString), \(longitudeString)"
    }
}
