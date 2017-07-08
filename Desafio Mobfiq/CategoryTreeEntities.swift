//
//  CategoryTreeEntities.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

// estrutura e dados que interessam no json vindo da api
struct CategoryTree {
    var categories: [Category] = [Category]()
}

struct Category {
    var name: String?
    var redirect : Redirect?
    var subcategories: [Category] = [Category]()
    var categoryListOrder = 0
    var categoryTreeOrder = 0
}

struct Redirect {
    var searchCriteria: [String: Any]?
}

// inicializadores
extension CategoryTree : DecodableEntity {
    init(withDictionary dict: [String:Any]) {
        if let categoryList = dict["Categories"] as? [[String:Any]] {
            for category in categoryList {
                self.categories.append(Category(withDictionary: category))
            }
        }
    }
}

extension Category : DecodableEntity {
    
    init(withDictionary dict: [String:Any]) {
        
        if let name = dict["Name"] as? String { self.name = name }

        if let categoryListOrder = dict["CategoryListOrder"] as? Int { self.categoryListOrder = categoryListOrder }
        if let categoryTreeOrder = dict["CategoryTreeOrder"] as? Int { self.categoryTreeOrder = categoryTreeOrder }
        
        if let redirect = dict["Redirect"] as? [String: Any] {
            self.redirect = Redirect(withDictionary:redirect)
        }
        
        if let categoryList = dict["SubCategories"] as? [[String:Any]] {
            for category in categoryList {
                self.subcategories.append(Category(withDictionary: category))
            }
        }
    }
}

extension Redirect : DecodableEntity {
    
    init(withDictionary dict: [String:Any]) {
        
        if let searchCriteria = dict["SearchCriteria"] as? [String: Any] {
            self.searchCriteria = searchCriteria
        }
    }
}
