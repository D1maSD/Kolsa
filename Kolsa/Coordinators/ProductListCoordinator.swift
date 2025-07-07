//
//  ProductListCoordinator.swift
//  Kolsa
//
//  Created by Dima Melnik on 7/5/25.
//

import UIKit

final class ProductListCoordinator {
    private let navigationController: UINavigationController
    private let productService: ProductProviding

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.productService = ProductService()
    }

    func start() {
        let viewModel = ProductListViewModel(productService: productService)
        let viewController = ProductListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
