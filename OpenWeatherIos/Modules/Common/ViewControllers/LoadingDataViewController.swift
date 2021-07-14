//
//  LoadingDataViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 13/07/2021.
//

import UIKit

class LoadingDataViewController: UIViewController, ViewModelSupporting {

    var viewModel: LoadingDataViewModel?

    private var retryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didTapRetryButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .white

        return activityIndicatorView
    }()

    private var logoImageView: UIImageView = {
        let image = UIImage(named: "small-logo")
        let imageView = UIImageView(image: image)

        return imageView
    }()

    lazy private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center

        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(activityIndicatorView)
        stackView.addArrangedSubview(retryButton)

        stackView.setCustomSpacing(10, after: activityIndicatorView)

        return stackView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = UIColor(named: "dodger-blue")

        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()

        bindActivityIndicatorIsLoading()
        bindRetryButtonIsHidden()

        viewModel?.loadData()
    }

    // MARK: - ui

    private func setupStackView() {
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func bindActivityIndicatorIsLoading() {
        viewModel?.activityIndicatorIsLoading.bind { [weak self] isLoading in
            guard let self = self else { return }

            isLoading ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }
    }

    private func bindRetryButtonIsHidden() {
        viewModel?.retryButtonIsHidden.bind { [weak self] isHidden in
            guard let self = self else { return }

            self.retryButton.isHidden = isHidden
        }
    }

    // MARK: - actions

    @objc private func didTapRetryButton(_ sender: UIButton) {
        viewModel?.loadData()
    }
}
