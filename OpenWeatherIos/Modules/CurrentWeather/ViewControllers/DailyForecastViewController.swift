//
//  DailyForecastViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 09/09/2021.
//

import UIKit

class DailyForecastViewController: UIViewController, ViewModelSupporting {

    private let dailyForecastHeaderReuseIdentifier = String(describing: DailyForecastHeader.self)
    private let dailyForecastValueCellReuseIdentifier = String(describing: DailyForecastValueCell.self)

    var viewModel: DailyForecastViewModel?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsSelection = false

        tableView.register(
            DailyForecastHeader.self,
            forHeaderFooterViewReuseIdentifier: dailyForecastHeaderReuseIdentifier
        )
        tableView.register(
            DailyForecastValueCell.self,
            forCellReuseIdentifier: dailyForecastValueCellReuseIdentifier
        )

        tableView.dataSource = self
        tableView.delegate   = self

        return tableView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()

        navigationItem.title = "\(viewModel?.dailyForecastsCount ?? 0)-day forecast"

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeUnitHandler),
            name: .didChangeUnit,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let navigationBar = navigationController?.navigationBar

        navigationBar?.setBackgroundImage(nil, for: .default)
        navigationBar?.shadowImage = nil
        navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }

    // setup UI

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }

    // MARK: - actions

    @objc private func didChangeUnitHandler() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension DailyForecastViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.headerModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let header = viewModel?.headerModelList[section] else {
            return 0
        }

        if header.isExpanded == false {
            return 0
        }

        return viewModel?.headerModelList[section].rowModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: dailyForecastValueCellReuseIdentifier,
            for: indexPath
        ) as? DailyForecastValueCell

        cell?.timeZone = viewModel.timeZone
        cell?.settings = viewModel.appDataManager.settings
        cell?.rowModel = viewModel.headerModelList[indexPath.section].rowModelList[indexPath.row]

        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension DailyForecastViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else {
            return nil
        }

        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: dailyForecastHeaderReuseIdentifier
        ) as? DailyForecastHeader

        let headerModel = viewModel.headerModelList[section]
        headerView?.timeZone = viewModel.timeZone
        headerView?.settings = viewModel.appDataManager.settings
        headerView?.headerModel = headerModel

        headerView?.didTapToggleButtonHandler = {
            let isExpanded = headerModel.isExpanded
            viewModel.setIsExpanded(!isExpanded, at: section)

            tableView.reloadSections([section], with: .fade)
        }

        return headerView
    }
}
