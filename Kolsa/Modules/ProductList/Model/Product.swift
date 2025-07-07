//
//  File.swift
//  Kolsa
//
//  Created by Dima Melnik on 7/5/25.
//

import Foundation

struct Product: Decodable {
    let id: String
    let name: String
    let description: String
    let price: Double
}
