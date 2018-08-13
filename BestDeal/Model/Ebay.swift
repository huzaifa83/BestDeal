//
//  Ebay.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 25/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import Foundation

struct EbayProduct: Codable {
    let findItemsByKeywordsResponse: [FindItemsByKeywordsResponse]
}

struct FindItemsByKeywordsResponse: Codable {
    let searchResult: [SearchResult]
}

struct SearchResult: Codable {
    let item: [EbayItem]
    
    enum CodingKeys: String, CodingKey {
        case item = "item"
    }
}

struct EbayItem: Codable {
    let itemID, title, globalID: [String]?
    let galleryURL, viewItemURL: [String]?
    let sellerInfo: [SellerInfo]?
    let sellingStatus: [SellingStatus]?
    let topRatedListing: [String]?
    
    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case title
        case globalID = "globalId"
        case galleryURL, viewItemURL, sellerInfo, sellingStatus, topRatedListing
    }
}

struct SellerInfo: Codable {
    let positiveFeedbackPercent, feedbackRatingStar: [String]?
}

struct SellingStatus: Codable {
    let currentPrice: [ConvertedCurrentPrice]?
    let convertedCurrentPrice: [ConvertedCurrentPrice]?
}

struct ConvertedCurrentPrice: Codable {
    let currencyID, value: String
    
    enum CodingKeys: String, CodingKey {
        case currencyID = "@currencyId"
        case value = "__value__"
    }
}
