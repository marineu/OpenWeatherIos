//
//  CurrentWeatherController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 02/05/2021.
//

import UIKit

class CurrentWeatherController: UIViewController, ViewModelNavigatorSupporting {

    var viewModel: CurrentWeatherViewModel?

    var navigator: CurrentWeatherNavigator?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never

        tableView.dataSource = self

        tableView.register(CurrentWeatherCell.self, forCellReuseIdentifier: CellType.current.rawValue)
        tableView.register(ShortDailyCell.self, forCellReuseIdentifier: CellType.daily.rawValue)
        tableView.register(HourlyForecastCell.self, forCellReuseIdentifier: CellType.hourly.rawValue)
        tableView.register(
            AdditionalWeatherCell.self,
            forCellReuseIdentifier: CellType.currentAdditional.rawValue
        )
        tableView.register(SunsetCell.self, forCellReuseIdentifier: CellType.sunset.rawValue)

        tableView.addSubview(refreshControl)

        return tableView
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshControlHandler), for: .valueChanged)

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        bindReloadTableView()
        bindIsLoading()
        bindErrorMessage()

        DispatchQueue.main.async {
            self.viewModel?.loadData()
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeUnitHandler),
            name: .didChangeUnit,
            object: nil
        )
    }

    // MARK: - setup UI

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }

            (self.weatherPageViewController as? MainWeatherPageViewController)?
                .updateBackgroundView(with: self)
            self.tableView.reloadData()
        }
    }

    private func bindIsLoading() {
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self = self else {
                return
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else {
                    return
                }

                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
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

    // MARK: - actions

    @objc private func refreshControlHandler() {
        viewModel?.loadData()
    }

    @objc private func didChangeUnitHandler() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension CurrentWeatherController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellTypes.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cellType = viewModel.cellTypes[indexPath.row]

        switch cellType {
        case .current:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellType.current.rawValue,
                for: indexPath
            ) as? CurrentWeatherCell

            let cityWeatherForecast = viewModel.cityWeatherForecast

            cell?.currentWeather = cityWeatherForecast.oneCallResponse.current
            cell?.settings = viewModel.appDataManager.settings

            return cell ?? UITableViewCell()
        case .daily:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellType.daily.rawValue,
                for: indexPath) as? ShortDailyCell

            let cityWeatherForecast = viewModel.cityWeatherForecast
            let daily = cityWeatherForecast.oneCallResponse.daily ?? []

            cell?.dailyForecasts = Array(daily[0..<3])
            cell?.settings = viewModel.appDataManager.settings
            cell?.dailyForecastsCount = daily.count
            cell?.timeZone = viewModel.timeZone
            cell?.didTapButtonHandler = { [unowned self] in
                self.navigator?.navigate(to: .dailyForecast((daily, viewModel.timeZone)))
            }

            return cell ?? UITableViewCell()
        case .hourly:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellType.hourly.rawValue,
                for: indexPath) as? HourlyForecastCell

            cell?.hourlyForecasts = viewModel.hourlyForecasts
            cell?.settings = viewModel.appDataManager.settings
            cell?.timeZone = viewModel.timeZone

            return cell ?? UITableViewCell()
        case .currentAdditional:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellType.currentAdditional.rawValue,
                for: indexPath) as? AdditionalWeatherCell

            let cityWeatherForecast = viewModel.cityWeatherForecast

            cell?.currentWeather = cityWeatherForecast.oneCallResponse.current
            cell?.settings = viewModel.appDataManager.settings

            return cell ?? UITableViewCell()
        case .sunset:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CellType.sunset.rawValue,
                for: indexPath) as? SunsetCell

            let cityWeatherForecast = viewModel.cityWeatherForecast

            cell?.currentWeather = cityWeatherForecast.oneCallResponse.current
            cell?.timeZone = viewModel.timeZone

            return cell ?? UITableViewCell()
        }
    }
}

extension CurrentWeatherController: ErrorAlertSupporting {
}
