//
//  UnitPickerViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import UIKit

class UnitPickerViewController: UIViewController, ViewModelSupporting {

    private let tableViewCellReuseIdentifier = String(describing: UITableViewCell.self)

    var viewModel: UnitPickerViewModel?

    var didTapDoneButtonHandler: ((UnitPickerViewModel.UniversalUnit, UnitType) -> Void)?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.dataSource = self
        tableView.delegate   = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellReuseIdentifier)

        return tableView
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDoneButton)
        )

        setupTableView()
    }

    // MARK: - setup UI

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
    }

    // MARK: - actions

    @objc private func didTapDoneButton() {
        guard let viewModel = viewModel else {
            return
        }

        didTapDoneButtonHandler?(viewModel.inputData.selectedUnit, viewModel.inputData.unitType)
    }
}

extension UnitPickerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.inputData.units.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: tableViewCellReuseIdentifier,
            for: indexPath
        )

        if let viewModel = viewModel {
            cell.textLabel?.text = viewModel.inputData.units[indexPath.row].description
            let unit = viewModel.inputData.units[indexPath.row]
            cell.accessoryType = unit.raw == viewModel.inputData.selectedUnit.raw ? .checkmark : .none
        }

        return cell
    }
}

extension UnitPickerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard
            let viewModel = viewModel
        else {
            return
        }

        let selectedUnit = viewModel.inputData.selectedUnit
        let unit = viewModel.inputData.units[indexPath.row]
        let units = viewModel.inputData.units

        guard
            let cell = tableView.cellForRow(at: indexPath),
            let previousSelectedRow = units.firstIndex(where: { $0.raw == selectedUnit.raw }),
            let previousSelectedCell = tableView
                .cellForRow(at: IndexPath(row: previousSelectedRow, section: 0)),
            cell != previousSelectedCell
        else {
            return
        }

        cell.accessoryType = .checkmark
        previousSelectedCell.accessoryType = .none
        viewModel.inputData.selectedUnit = unit
    }
}
