//
//  StorePreferenceService.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class StorePreferenceService : MobfiqService {
    
    var client: RestApiClient = RestApiClient()
    var lastRequest: URLRequest?
    
    init(_ apiClient: RestApiClient) {
        self.client = apiClient
    }
    
    func fetchCategoryTree(completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let request = NSMutableURLRequest(url: URL(string: MobfiqServiceEndpoint.StorePreferenceCategoryTree.rawValue)!)
        
        self.client.get(request: request) { (success, object) -> () in
            if success {
                guard let jsonString = object as? String else {
                    completion(false, "No response" as AnyObject)
                    return;
                }
                if let categoryTree : CategoryTree = try! self.parseJson(jsonString) {
                    completion(true, categoryTree as AnyObject)
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
