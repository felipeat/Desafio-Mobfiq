//
//  ProductSearchService.swift
//  Desafio Mobfiq
//
//  Created by Pro on 28/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class ProductSearchService {
    
    static let kDefaultMaxItems = 10
    static let kDefaultOffset = 0
    
    // incompleto. falta a chamada a api
    func buscarprodutos(query: String, max count: Int = kDefaultMaxItems, offset: Int = kDefaultOffset) -> [Product] {
        let jsonString = ""
        var products = [Product]()
        
        do {
            products.append(contentsOf: try parseSearchResultJson(jsonString))
        }
        catch {
            print("Parse error at \(#function)")
        }
        
        return products
    }
    
    private func parseSearchResultJson(_ json: String) throws -> [Product] {
        var products = [Product]()
        
        let jsonString = ""
        let jsonStringData = jsonString.data(using: .utf8)
        
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
