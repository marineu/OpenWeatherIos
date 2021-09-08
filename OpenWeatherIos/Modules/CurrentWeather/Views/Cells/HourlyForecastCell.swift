//
//  HourlyForecastCell.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 20/08/2021.
//

import UIKit

class HourlyForecastCell: UITableViewCell {

    var settings = Settings() {
        didSet {
            collectionView.reloadData()
        }
    }

    var hourlyForecasts: [HourlyForecast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    var timeZone: TimeZone = .current {
        didSet {
            collectionView.reloadData()
        }
    }

    private let collectionViewInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    private let collectionViewWidth: CGFloat = 100
    private let collectionViewHeight: CGFloat = 87

    private let cellReuseIdentifier = "hourlyForecastItemCell"

    lazy private var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.itemSize = CGSize(
            width: collectionViewWidth, height: collectionViewHeight
        )

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowLayout
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        collectionView.register(
            HourlyForecastItemCell.self,
            forCellWithReuseIdentifier: cellReuseIdentifier
        )
        collectionView.dataSource = self

        return collectionView
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
        contentView.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
        collectionView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: collectionViewInset.top).isActive = true
        collectionView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: collectionViewInset.left).isActive = true

        contentView.bottomAnchor.constraint(
            equalTo: collectionView.bottomAnchor,
            constant: collectionViewInset.bottom).isActive = true
        contentView.trailingAnchor.constraint(
            equalTo: collectionView.trailingAnchor,
            constant: collectionViewInset.right).isActive = true
    }
}

// MARK: - UICollectionViewDataSource

extension HourlyForecastCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecasts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseIdentifier,
            for: indexPath
        ) as? HourlyForecastItemCell

        let hourlyForecast = hourlyForecasts[indexPath.item]
        cell?.hourlyForecast = hourlyForecast
        cell?.settings = settings
        cell?.timeZone = timeZone

        return cell ?? UICollectionViewCell()
    }
}
