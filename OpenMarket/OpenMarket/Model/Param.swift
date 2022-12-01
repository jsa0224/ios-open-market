//
//  Param.swift
//  OpenMarket
//
//  Created by 정선아 on 2022/11/30.
//

import Foundation

struct Param: Codable {
    let name, welcomeDescription: String
    let price: Int
    let currency: String
    let discountedPrice, stock: Int
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name
        case welcomeDescription = "description"
        case price, currency
        case discountedPrice = "discounted_price"
        case stock, secret
    }
}
