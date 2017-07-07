//
//  MobfiqService.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class MobfiqService {
    
    func parseJson<T: DecodableEntity>(_ json: String) throws -> T? {
        var entityObject: T? = nil
        
        let jsonStringData = json.data(using: .utf8)
        
        if let data = jsonStringData,
            let jsonDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            entityObject = T(withDictionary: jsonDictionary)
        }
        
        return entityObject
    }    
}

enum MobfiqServiceEndpoint : String {
    case SearchCriteria = "https://desafio.mobfiq.com.br/Search/Criteria"
    case StorePreferenceCategoryTree = "https://desafio.mobfiq.com.br/StorePreference/CategoryTree"
}
