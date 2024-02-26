//
//  LocationListViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 12/09/2021.
//

import UIKit

class LocationListViewController: UIViewController, ViewModelSupporting {

    private let locationWeatherCellReuseIdentifier = String(describing: LocationWeatherCell.self)

    var viewModel: LocationListViewModel?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.dataSource = self
        tableView.delegate   = self

        tableView.register(
            LocationWeatherCell.self,
            forCellReuseIdentifier: locationWeatherCellReuseIdentifier
        )

        return tableView
    }()

    lazy private var searchController: UISearchController = {
        let locationSearchResultsController = LocationSearchResultsController()
        locationSearchResultsController.viewModel = LocationSearchResultsViewModel(
            appDataManager: viewModel?.appDataManager ?? AppDataManager.shared
        )

        let searchController = UISearchController(searchResultsController: locationSearchResultsController)
        searchController.searchBar.placeholder = "Enter location"
        searchController.searchResultsUpdater  = locationSearchResultsController

        return searchController
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchResultsController = searchController
            .searchResultsController as? LocationSearchResultsController
        searchResultsController?.didSelectResultHandler = { [weak self] city in
            guard let self = self else {
                return
            }

            self.viewModel?.addCity(city)

            let nextIndex = self.tableView.numberOfRows(inSection: 0)
            let indexPath = IndexPath(row: nextIndex, section: 0)

            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.searchController.isActive = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.viewModel?.loadData(for: city, isChangedList: true)
            }
        }

        navigationItem.searchController = searchController
        navigationItem.title = "Manage cities"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(didTapEditButton)
        )

        definesPresentationContext = true

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeUnitHandler),
            name: .didChangeUnit,
            object: nil
        )

        setupTableView()

        bindReloadTableView()
        bindIsLoading()
        bindErrorMessage()
        bindCityListDidChange()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        viewModel?.updateData()
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
            let count = self.viewModel?.cityWeatherForecasts.count ?? 0
            self.navigationItem.rightBarButtonItem?.isEnabled = count > 1
        }
    }

    private func bindIsLoading() {
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self = self else {
                return
            }

            self.view.isUserInteractionEnabled = !isLoading
        }
    }

    private func bindErrorMessage() {
        viewModel?.errorMessage.bind { [weak self] errorMessage in
            guard
                let self = self,
                let errorMessage = errorMessage
            else {
                return
            }

            self.showAlert(in: self, title: "Error", message: errorMessage, dismissTitle: "OK")
        }
    }

    private func bindCityListDidChange() {
        viewModel?.cityListDidChange.bind { isChanged in
            guard isChanged == true else {
                return
            }

            NotificationCenter.default.post(name: .didChangeLocations, object: nil)
        }
    }

    // MARK: - actions

    @objc private func didTapEditButton() {
        tableView.isEditing.toggle()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: tableView.isEditing ? .done : .edit,
            target: self,
            action: #selector(didTapEditButton)
        )
    }

    @objc private func didChangeUnitHandler() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension LocationListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cityWeatherForecasts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: locationWeatherCellReuseIdentifier,
            for: indexPath
        ) as? LocationWeatherCell

        cell?.cityWeatherForecast = viewModel?.cityWeatherForecasts[indexPath.row]
        cell?.settings = viewModel?.appDataManager.settings ?? Settings()

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return tableView.isEditing ? .none : .delete
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - UITableViewDelegate

extension LocationListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
        }

        let cityWeatherForecast = viewModel.cityWeatherForecasts[indexPath.row]

        if viewModel.needToUpdate(cityWeatherForecast: cityWeatherForecast) {
            viewModel.loadData(for: cityWeatherForecast.city, isChangedList: false)
            return
        }

        NotificationCenter.default.post(name: .didSelectLocation, object: indexPath.row)
        tabBarController?.selectedIndex = 0
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            viewModel?.deleteCity(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        viewModel?.moveCity(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension LocationListViewController: ErrorAlertSupporting {
}

extension Notification.Name {

    static let didChangeLocations = Notification.Name("didChangeLocations")
    static let didSelectLocation  = Notification.Name("didSelectLocation")
}
