//
//  ProductSearchService.swift
//  Desafio Mobfiq
//
//  Created by Pro on 28/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class ProductSearchService : MobfiqService {
    
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
    
    func query(withString query: String, maxResults count: Int, offset: Int, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let simpleCriteria = [ProductSearchService.kQueryBodyKey : query, ProductSearchService.kOffsetBodyKey : offset, ProductSearchService.kSizeBodyKey : count] as [String : Any]
        self.query(withSearchCriteria: simpleCriteria, completion: completion)
    }
    
    func query(withSearchCriteria criteria: [String: Any?], completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let request = NSMutableURLRequest(url: URL(string: MobfiqServiceEndpoint.SearchCriteria.rawValue)!)
        request.setValue(ProductSearchService.kContentType, forHTTPHeaderField: "Content-Type")
        
        
        if let httpBody = try? JSONSerialization.data(withJSONObject: criteria) {
            request.httpBody = httpBody
        }
        
        self.client.post(request: request) { (success, object) -> () in
            if success {
                guard let jsonString = object as? String else {
                    completion(false, "No response" as AnyObject)
                    return;
                }
                if let searchResult : SearchResult = try! self.parseJson(jsonString) {
                    completion(true, searchResult as AnyObject)
                }
                else {
                    completion(false, "Invalid response" as AnyObject)
                }
            }
            else {
                completion(false, object as? NSString)
            }
        }
        
        self.lastRequest = request as URLRequest
    }

}

// MARK - Criteria Builder

class SearchCriteriaBuilder {
    func simpleCriteriaObject(withQuery query: String, offset : Int = 0, size : Int = 10) -> [String: Any?] {
        return ["Query" : query, "Offset" : offset, "Size" : size]
    }
    func fullCriteriaObject(withQuery query: String) -> [String: Any?] {
        var criteria = self.simpleCriteriaObject(withQuery: query)
        criteria["OrderBy"] = nil
        criteria["Filter"] = nil
        criteria["ApiQuery"] = nil
        criteria["ProductId"] = nil
        criteria["Hotsite"] = nil
        criteria["RealProductId"] = nil
        criteria["EAN"] = nil
        criteria["RealProductIdGroup"] = nil
        criteria["FacetItems"] = nil
        criteria["SearchApi"] = nil
        
        return criteria
    }
}
