////
////  Kolsa
////
////  Created by Dima Melnik on 7/5/25.
////
//
import UIKit

protocol ProductProviding {
    func loadProducts() -> [Product]
}

final class ProductService: ProductProviding {
    func loadProducts() -> [Product] {
            guard let url = Bundle.main.url(forResource: "Products", withExtension: "json") else {
                return []
            }

            do {
                let data = try Data(contentsOf: url)
                let products = try JSONDecoder().decode([Product].self, from: data)
                return products
            } catch {
                return []
            }
        }
}
