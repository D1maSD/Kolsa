//
//  Kolsa
//
//  Created by Dima Melnik on 7/5/25.
//

import Foundation

final class ProductListViewModel {
    private let productService: ProductProviding
    private(set) var products: [Product] = []
    private(set) var sortedProducts: [Product] = []
    var sortingType: SortingType = .name

    init(productService: ProductProviding) {
        self.productService = productService
        self.products = productService.loadProducts()
        sort()
    }

    func sort() {
        switch sortingType {
        case .price:
            sortedProducts = products.sorted(by: { $0.price < $1.price })
        case .name:
            sortedProducts = products.sorted(by: { $0.name < $1.name })
        }
    }

    func toggleSort() {
        sortingType = sortingType.toggle
        sort()
    }
}
