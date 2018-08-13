//
//  File.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 30/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import UIKit

class ProductFacade {
    
    let walmartController = WalmartController()
    let ebayController = EbayController()
    
    
    var products: [GeneralProduct]? = [GeneralProduct]() {
        didSet {
            self.products = self.products?.sorted(by: {Int($0.salePrice!) < Int($1.salePrice!)})
        }
    }
    
    static var favoriteProducts: [GeneralProduct] = []
    
    func fetchProducts(productName: String, completion: @escaping (([GeneralProduct]?) -> Void)) {
        products = []
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        walmartController.fetchProduct(productName: productName) { (walmartProducts) in
            guard let walmartProducts = walmartProducts else {
                
                dispatchGroup.leave()
                return
            }
            self.products?.append(contentsOf: walmartProducts)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ebayController.fetchProduct(productName: productName) { (ebayProducts) in
            guard let ebayProducts = ebayProducts else {
                dispatchGroup.leave()
                return
            }
            self.products?.append(contentsOf: ebayProducts)
            dispatchGroup.leave()
        }
        
        dispatchGroup.wait()
        completion(self.products)
        fetchImage(generalProducts: productName) { (image) in
            
        }
        
    }
    
    func fetchImage(generalProducts: String, completion: @escaping (UIImage?) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        walmartController.fetchImage(urlAsString: generalProducts) { (image) in
            guard let image = image else { return }
            
            completion(image)
            dispatchGroup.leave()
            return
        }
        dispatchGroup.enter()
        ebayController.fetchImage(urlAsString: generalProducts) { (image) in
            guard let image = image else { return }
            
            completion(image)
            dispatchGroup.leave()
            return
        }
        
    }
    
    
    //    static func isFavoriteProduct(generalProduct: GeneralProduct) -> GeneralProduct? {
    //        var generalProduct = generalProduct
    //        guard let upc = generalProduct.upc else { return nil }
    //        generalProduct.isFavorites.append(upc)
    //        favoriteProducts.append(generalProduct)
    //        //print("🍍 \(generalProduct.isFavorites.count)")
    //        return generalProduct
    //    }
    
    
}
