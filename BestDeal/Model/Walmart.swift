//
//  Walmart.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 24/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import Foundation

struct Product: Codable {
    let items: [WalmartItem]
}

struct WalmartItem: Codable {
    let name: String?
    let msrp, salePrice: Double?
    let upc: String?
    let shortDescription: String?
    let mediumImage: String?
    let customerRating: String?
    let numReviews: Int?
    let customerRatingImage: String?
    let companyId: String? =  "Walmart"
    let addToCartURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, msrp, salePrice, upc, shortDescription, mediumImage
        case customerRating, numReviews, customerRatingImage
        case addToCartURL = "addToCartUrl"
    }
}
