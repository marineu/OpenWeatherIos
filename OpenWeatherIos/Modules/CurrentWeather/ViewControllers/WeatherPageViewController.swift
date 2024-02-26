//
//  WeatherPageViewController.swift
//  OpenWeatherIos
//
//  Created by Marin Ipati on 06/08/2021.
//

import UIKit

class WeatherPageViewController: UIViewController {

    var emptyViewController: UIViewController?

    var selectedIndex: Int {
        get {
            guard let firstViewController = pageViewController.viewControllers?.first else {
                return NSNotFound
            }

            return allViewControllers.firstIndex(of: firstViewController) ?? NSNotFound
        }

        set {
            let selectedViewController = allViewControllers[newValue]
            pageViewController.setViewControllers(
                [selectedViewController],
                direction: .forward,
                animated: false
            )
            pageViewController(
                pageViewController,
                didChangePageAt: selectedIndex,
                withViewController: selectedViewController
            )
        }
    }

    private(set) var allViewControllers: [UIViewController] = []

    lazy private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )

        pageViewController.dataSource = self
        pageViewController.delegate   = self

        return pageViewController
    }()

    override func loadView() {
        let view = SkyView(skyType: .default)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(pageViewController)
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        if !allViewControllers.isEmpty {
            setAllViewControllers([emptyViewController ?? UIViewController()])
        }
    }

    public func setAllViewControllers(_ viewControllers: [UIViewController]) {
        allViewControllers = viewControllers.isEmpty
            ? [emptyViewController ?? UIViewController()] : viewControllers
        selectedIndex = 0
    }

    public func addViewController(_ viewController: UIViewController) {
        allViewControllers.append(viewController)
    }

    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didChangePageAt index: Int,
        withViewController: UIViewController
    ) {}
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

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allViewControllers.count > 1 ? allViewControllers.count : 0
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let viewController = pageViewController.viewControllers?.first else {
            return 0
        }

        return allViewControllers.firstIndex(of: viewController) ?? 0
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
            self.pageViewController(
                pageViewController,
                didChangePageAt: selectedIndex,
                withViewController: allViewControllers[selectedIndex]
            )
        }
    }
}

extension UIViewController {

    var weatherPageViewController: WeatherPageViewController? {
        if parent is WeatherPageViewController {
            return parent as? WeatherPageViewController
        }

        return parent?.weatherPageViewController
    }
}
