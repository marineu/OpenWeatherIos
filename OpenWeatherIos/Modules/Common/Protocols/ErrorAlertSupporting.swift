//
//  ErrorAlertSupporting.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 15/09/2021.
//

import UIKit

public protocol ErrorAlertSupporting {

    func showAlert(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        dismissTitle: String?,
        dismissHandler: (() -> Void)?
    )
}

extension ErrorAlertSupporting {

    public func showAlert(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        dismissTitle: String?,
        dismissHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: dismissTitle, style: .cancel) { _ in
            dismissHandler?()
        }

        alert.addAction(dismissAction)

        viewController.present(alert, animated: true)
    }
}
