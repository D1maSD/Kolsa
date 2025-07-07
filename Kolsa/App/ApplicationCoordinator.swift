//
//  ApplicationCoordinator.swift
//  Kolsa
//
//  Created by Dima Melnik on 7/5/25.
//

import UIKit

final class ApplicationCoordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var productListCoordinator: ProductListCoordinator?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        productListCoordinator = ProductListCoordinator(navigationController: navigationController)
        productListCoordinator?.start()
    }
}
