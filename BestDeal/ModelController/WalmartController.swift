//
//  WalmartController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 24/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//
import UIKit
import Foundation


class WalmartController {
    
     let baseURL = URL(string: "http://api.walmartlabs.com/v1/search?")
    
     func fetchProduct(productName: String, completion: @escaping (([GeneralProduct]?) -> Void)) {
        ///URL : Step 1
        guard let url = baseURL  else {completion(nil); return}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let apiKey = URLQueryItem.init(name: "apiKey", value: Constants.walmartApi)
        let productName = URLQueryItem.init(name: "query", value: productName)
        let facet = URLQueryItem.init(name: "facet", value: "on")
        components?.queryItems = [apiKey, productName, facet]
        
        guard let fullConsolidatedURL = components?.url else {completion(nil); return}
        
        print(fullConsolidatedURL.absoluteString)
        
        // Request
        var request = URLRequest(url: fullConsolidatedURL) // Have to attach the final url
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // URLsesssion + Resume + Decode
        URLSession.shared.dataTask(with: request) {(data,_,error) in
            if let error = error  {
                print("Error sending request \(error) \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil); return }
            print("data is : \(data)")
            do {
                let jsonDecoder = JSONDecoder()
                let products = try jsonDecoder.decode(Product.self, from: data)
                let items = products.items
                completion( items.compactMap { GeneralProduct(walmartItemService: $0) } )
                return
            } catch {
                print("Error decoding data \(error.localizedDescription)")
                completion(nil)
                return
            }
            }.resume()
        
    }
    
    func fetchImage(urlAsString: String, completion: @escaping ((UIImage?)->Void)){
        
        guard let baseUrl = URL(string: urlAsString) else {completion(nil); return}
        print(baseUrl.absoluteString)
        
        
        // Request
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        
        // URLSession + Resume + Decode
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching dataTask \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil); return}
            let image = UIImage(data: data)
            completion(image)
            }.resume()
        
    }
    
}

