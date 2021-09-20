//
//  NoItemsViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import UIKit

class NoItemsViewController: UIViewController, ViewModelSupporting {

    var viewModel: NoItemsViewModel?

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No weather data"
        label.textColor = .white

        return label
    }()

    private let goButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Go to manage cities", for: .normal)
        button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        button.backgroundColor = .white
        button.setTitleColor(.dodgerBlue, for: .normal)
        button.setTitleColor(.dodgerBlue.withAlphaComponent(0.2), for: .highlighted)
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        return button
    }()

    lazy private var stackView: UIStackView = {
        let arrangedSubviews = [messageLabel, goButton]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16

        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()

        bindReloadData()
        bindIsLoading()
        bindErrorMessage()

        viewModel?.requestLocation()
    }

    // MARK: - setup UI

    private func setupStackView() {
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    // MARK: - bind UI

    private func bindReloadData() {
        viewModel?.reloadData.bind { [weak self] success in
            guard
                let self = self,
                success
            else {
                return
            }

            (self.weatherPageViewController as? MainWeatherPageViewController)?.reloadData()
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

    // MARK: - actions

    @objc private func didTapRetryButton() {
        tabBarController?.selectedIndex = 1
    }
}

extension NoItemsViewController: ErrorAlertSupporting {
}
