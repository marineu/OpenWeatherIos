//
//  WeatherPageViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/08/2021.
//

import UIKit

class WeatherPageViewController: UIViewController {

    private(set) var selectedIndex: Int = 0

    private var allViewControllers: [UIViewController] = []

    private var allSkyTypes: [SkyType] = []

    lazy private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )

        pageViewController.dataSource = self
        pageViewController.delegate   = self

        return pageViewController
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func loadView() {
        let view = SkyView(skyType: .clearNight)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(pageViewController)
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        if allViewControllers.indices.contains(selectedIndex) {
            pageViewController.setViewControllers(
                [allViewControllers[selectedIndex]],
                direction: .forward,
                animated: false
            )
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension WeatherPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let index = allViewControllers.firstIndex(of: viewController),
            index > 0
        else {
            return nil
        }

        return allViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let index = allViewControllers.firstIndex(of: viewController),
            allViewControllers.count - index > 1
        else {
            return nil
        }

        return allViewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate

extension WeatherPageViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if completed {
            guard let firstViewController = pageViewController.viewControllers?.first else {
                return
            }

            let index = allViewControllers.firstIndex(of: firstViewController) ?? 0
            selectedIndex = index

            (view as? SkyView)?.skyType = allSkyTypes[selectedIndex]
        }
    }
}
