//
//  Walmart.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 24/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import Foundation


// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct Product: Codable {
    let items: [Item]
}

struct Item: Codable {
    let name: String?
    let msrp, salePrice: Double?
    let upc: String?
    let shortDescription: String?
    let thumbnailImage, mediumImage, largeImage: String?
    let customerRating: String?
    let numReviews: Int?
    let customerRatingImage: String?
    let addToCartURL, affiliateAddToCartURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name, msrp, salePrice, upc, shortDescription, thumbnailImage, mediumImage, largeImage
        case customerRating, numReviews, customerRatingImage
        case addToCartURL = "addToCartUrl"
        case affiliateAddToCartURL = "affiliateAddToCartUrl"
    }
}
