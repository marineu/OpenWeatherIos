//
//  UnitTypeCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import UIKit

class UnitTypeCell: UITableViewCell {

    var rowModel: SettingsViewModel.RowModel? {
        didSet {
            guard let rowModel = rowModel else {
                return
            }

            titleLabel.text = rowModel.title
            valueLabel.text = rowModel.value
        }
    }

    private let contentViewInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    // MARK: - subviews declaration

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.numberOfLines = 0

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    lazy private var stackView: UIStackView = {
        let arrangedSubviews = [titleLabel, valueLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
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
        accessoryType = .disclosureIndicator

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
}
