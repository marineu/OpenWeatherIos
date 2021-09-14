//
//  LocationSearchResultsController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/09/2021.
//

import UIKit

class LocationSearchResultsController: UIViewController, ViewModelSupporting {

    private let locationSearchResultCellReuseIdentifier = String(describing: LocationSearchResultCell.self)

    var viewModel: LocationSearchResultsViewModel?

    var didSelectResultHandler: ((City) -> Void)?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear

        tableView.dataSource = self
        tableView.delegate   = self

        tableView.register(
            LocationSearchResultCell.self,
            forCellReuseIdentifier: locationSearchResultCellReuseIdentifier
        )

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        bindReloadTableView()
    }

    // MARK: - setup UI

    private func setupTableView() {
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }

    // MARK: - bind UI

    private func bindReloadTableView() {
        viewModel?.reloadTableView.bind { [weak self] _ in
            guard let self = self else {
                return
            }

            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension LocationSearchResultsController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        viewModel?.searchLocation(by: text)
    }
}

// MARK: - UITableViewDataSource

extension LocationSearchResultsController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cities.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: locationSearchResultCellReuseIdentifier,
            for: indexPath
        ) as? LocationSearchResultCell

        let city = viewModel.cities[indexPath.row]
        cell?.city = city

        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension LocationSearchResultsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }

        let city = viewModel.cities[indexPath.row]
        didSelectResultHandler?(city)
    }
}
