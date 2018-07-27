//
//  EbayController.swift
//  BestDeal
//
//  Created by Huzaifa Gadiwala on 25/7/18.
//  Copyright © 2018 Huzaifa Gadiwala. All rights reserved.
//

import Foundation


class EbayController {
    
    static let baseURL = URL(string: "http://svcs.ebay.com/services/search/FindingService/v1?")
    
    static func fetchProduct(productName: String, completion: @escaping (([EbayItem]?) -> Void)) {
        ///URL : Step 1
        guard let url = baseURL  else {completion(nil); return}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let operationName = URLQueryItem.init(name: "OPERATION-NAME", value: "findItemsByKeywords")
        let serviceVersion = URLQueryItem.init(name: "SERVICE-VERSION", value: "1.0.0")
        let securityApp = URLQueryItem.init(name: "SECURITY-APPNAME", value: Constants.ebayApi)
        let responseFormat = URLQueryItem.init(name: "RESPONSE-DATA-FORMAT", value: "JSON&REST-PAYLOAD")
        //let buyerCode = URLQueryItem.init(name: "buyerPostalCode", value: "95060")
        //let sortOrder = URLQueryItem.init(name: "sortOrder", value: "Distance")
        let sellerInfo = URLQueryItem.init(name: "outputSelector", value: "SellerInfo")
        let keywords = URLQueryItem.init(name: "keywords", value: productName)
        components?.queryItems = [operationName, serviceVersion, securityApp, responseFormat,  sellerInfo, keywords]
        
        guard let fullConsolidatedURL = components?.url else {completion(nil); return}
        
        guard let fullURLString = fullConsolidatedURL.absoluteString.removingPercentEncoding else {completion(nil); return}
        
        guard let removePercentagesURL = URL(string: fullURLString) else  {completion(nil); return}
        
        print(removePercentagesURL)
        
        // Request
        var request = URLRequest(url: removePercentagesURL) // Have to attach the final url
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
                let product = try jsonDecoder.decode(EbayProduct.self, from: data)
                let topSearchResult = product.findItemsByKeywordsResponse[0].searchResult[0]
                let items = topSearchResult.item
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
