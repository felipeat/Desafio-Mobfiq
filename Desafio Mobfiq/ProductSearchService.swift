//
//  ProductSearchService.swift
//  Desafio Mobfiq
//
//  Created by Pro on 28/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class ProductSearchService {
    
    static let endpoint = "https://desafio.mobfiq.com.br/Search/Criteria"
    static let kContentType = "application/json"
    
    // body keys
    static let kQueryBodyKey = "Query"
    static let kOffsetBodyKey = "Offset"
    static let kSizeBodyKey = "Size"
    
    // body default values
    static let kDefaultMaxItems = 10
    static let kDefaultOffset = 0
    
    var client: RestApiClient = RestApiClient()
    var lastRequest: URLRequest?
    
    init(_ apiClient: RestApiClient) {
        self.client = apiClient
    }
    
    func query(_ query: String, maxResults count: Int = kDefaultMaxItems, offset: Int = kDefaultOffset, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let request = NSMutableURLRequest(url: URL(string: ProductSearchService.endpoint)!)
        request.setValue(ProductSearchService.kContentType, forHTTPHeaderField: "Content-Type")
        
        let body = [ProductSearchService.kQueryBodyKey : query, ProductSearchService.kOffsetBodyKey : offset, ProductSearchService.kSizeBodyKey : count] as [String : Any]
        if let httpBody = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = httpBody
        }
        
        var products = [Product]()
        
        self.client.post(request: request) { (success, object) -> () in
            if success {
                guard let jsonString = object as? String else {
                    completion(false, "No response" as AnyObject)
                    return;
                }
                products = try! self.parseSearchResultJson(jsonString)
                completion(true, products as AnyObject)
            }
            else {
                completion(false, object as? NSString)
            }
        }
        
        self.lastRequest = request as URLRequest
    }
    
    private func parseSearchResultJson(_ json: String) throws -> [Product] {
        var products = [Product]()
        
        let jsonStringData = json.data(using: .utf8)
        
            if let data = jsonStringData,
                let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let productList = jsonDictionary["Products"] as? [[String: Any]] {
                for product in productList {
                    products.append(Product(withDictionary: product))
                }
            }
        
        return products
    }
}
