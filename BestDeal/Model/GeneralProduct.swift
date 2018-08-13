//
//  GeneralProduct.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 28/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

struct GeneralProduct {
    let companyId: String?
    let name: String
    let salePrice: Double?
    let upc: String?
    let mediumImage: String?
    let customerRating: String?
    let customerRatingImage: String?
    let addToCartURL: String?
    let source: Source

    var companyImage: UIImage? {
        guard let companyImage = companyId, let companyEnum = Company(rawValue: companyImage) else { return UIImage()}
        switch companyEnum {
        case .walmart:
            return UIImage(named: "walmart")
        case .ebay:
            return UIImage(named: "ebay")
        }
    }
    var ratingImage: UIImage? {
        guard let rating = customerRating, let ratingEnum = Rating(rawValue: (rating as NSString) .integerValue) else {
            return UIImage()
        }
        
        switch ratingEnum {
        case .oneStar:
            return UIImage(named: "oneStar")
        case .twoStar:
            return UIImage(named: "twoStars")
        case .threeStar:
            return UIImage(named: "threeStars")
        case .fourStar:
            return UIImage(named: "fourStars")
        case .fiveStar:
            return UIImage(named: "fiveStars")
            
        }
    }
    
    
    init?(walmartItemService: WalmartItem){
        guard let companyId = walmartItemService.companyId else {return nil}
        self.companyId = companyId
        guard let name = walmartItemService.name else {return nil}
        self.name = name
        guard let salePrice = walmartItemService.salePrice else {return nil}
        self.salePrice = salePrice
        guard let upc = walmartItemService.upc else {return nil}
        self.upc = upc
        guard let mediumImage = walmartItemService.mediumImage else {return nil}
        self.mediumImage = mediumImage
        guard let customerRating = walmartItemService.customerRating else {return nil}
        self.customerRating = customerRating
        guard let customerRatingImage = walmartItemService.customerRatingImage else {return nil}
        self.customerRatingImage = customerRatingImage
        guard let addToCartURL = walmartItemService.addToCartURL else {return nil}
        self.addToCartURL = addToCartURL
        self.source = .Walmart
    }
    
    
    init?(ebayItem: EbayItem){
        guard let companyId = ebayItem.globalID?.first else {return nil}
        
        
        
        self.companyId = companyId
        guard let name = ebayItem.title else {return nil}
        self.name = name[0]
        guard let salePrice = ebayItem.sellingStatus?.last?.convertedCurrentPrice?.first?.value else {return nil}
        self.salePrice = Double(salePrice)
        guard let upc = ebayItem.itemID?.first else {return nil}
        self.upc = upc
        guard let productURL = ebayItem.viewItemURL?.first else {return nil}
        self.addToCartURL = productURL
        guard let productImage = ebayItem.galleryURL?.first else {return nil}
        self.mediumImage = productImage
        guard let customerRating  = ebayItem.sellerInfo?.first?.positiveFeedbackPercent?.first else {return nil}
        let convertedRating = ((customerRating as NSString).integerValue)/20
        self.customerRating = String(convertedRating)
        guard let customerRatingImage = ebayItem.sellerInfo?.last?.feedbackRatingStar?.first else {return nil}
        self.customerRatingImage = customerRatingImage
        self.source = .Ebay

    }
}

extension GeneralProduct: Equatable{
   static func ==(lhs: GeneralProduct, rhs: GeneralProduct) -> Bool {
        return lhs.upc == rhs.upc
    }
    
}

enum Source: String{
    case Walmart = "Walmart"
    case Ebay = "Ebay"
}

enum Rating: Int{
    case oneStar = 1
    case twoStar = 2
    case threeStar = 3
    case fourStar = 4
    case fiveStar = 5
}

enum Company: String {
    case walmart = "Walmart"
    case ebay = "EBAY-US"
}
