//
//  WalmartController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 24/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import Foundation


class WalmartController {
    
    static let baseURL = URL(string: "http://api.walmartlabs.com/v1/search?")
    
    static func fetchProduct(productName: String, completion: @escaping (([Item]?) -> Void)) {
        ///URL : Step 1
        guard let url = baseURL  else {completion(nil); return}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKey = URLQueryItem.init(name: "apiKey", value: Constants.walmartApi)
        let productName = URLQueryItem.init(name: "query", value: productName)
        components?.queryItems = [apiKey, productName]
        
        guard let fullConsolidatedURL = components?.url else {completion(nil); return}
        
        print(fullConsolidatedURL.absoluteString)
        
        // Request
        var request = URLRequest(url: fullConsolidatedURL) // Have to attach the final url
        request.httpMethod = "GET"
        
        request.httpBody = nil
        
        // URLsesssion + Resume + Decode
        URLSession.shared.dataTask(with: request) {(data,_,error) in
            if let error = error  {
                print("Error sending request \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil); return }
            print("data is : \(data)")
            do {
                let jsonDecoder = JSONDecoder()
                let products = try jsonDecoder.decode(Product.self, from: data)
                let items = products.items
                completion(items)
                return
            } catch {
                print("Error decoding data \(error.localizedDescription)")
                completion(nil)
                return
            }
            }.resume()
        
    }
    
  
    
}

