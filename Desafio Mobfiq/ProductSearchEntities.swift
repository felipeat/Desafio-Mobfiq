//
//  ProductSearchEntities.swift
//  Desafio Mobfiq
//
//  Created by Pro on 28/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

// estrutura e dados que interessam no json vindo da api
struct SearchResult {
    var total: Int?
    var products : [Product] = [Product]()
}

struct Product {
    var name : String?
    var skus : [Sku] = [Sku]()
}

struct Sku {
    var name : String?
    var sellers : [Seller] = [Seller]()
    var images : [Image] = [Image]()
}

struct Seller {
    var price : Double?
    var listPrice : Double?
    var bestInstallment : BestInstallment?
}

struct Image {
    var imageUrl: String?
}

struct BestInstallment {
    var countInst: Int?
    var valueInst: Double?
    var totalInst: Double?
}


// inicializadores
extension SearchResult {
    init(withDictionary dict: [String:Any]) {
        if let total = dict["Total"] as? Int {
            self.total = total
        }
        
        if let productList = dict["Products"] as? [[String:Any]] {
            for product in productList {
                self.products.append(Product(withDictionary: product))
            }
        }
    }
}

extension Product {
    init(withDictionary dict: [String:Any]) {
        if let name = dict["Name"] as? String {
            self.name = name
        }
        
        if let skuList = dict["Skus"] as? [[String:Any]] {
            for sku in skuList {
                self.skus.append(Sku(withDictionary: sku))
            }
        }
    }
}

extension Sku {
    init(withDictionary dict: [String:Any]) {
        if let name = dict["Name"] as? String {
            self.name = name
        }
        
        if let sellerList = dict["Sellers"] as? [[String:Any]] {
            for seller in sellerList {
                self.sellers.append(Seller(withDictionary: seller))
            }
        }
        
        if let imageList = dict["Images"] as? [[String:Any]] {
            for image in imageList {
                if let imageUrl = image["ImageUrl"] as? String {
                    self.images.append(Image(imageUrl: imageUrl))
                }
            }
        }
    }
}

extension Seller {
    init(withDictionary dict: [String:Any]) {
        if let price = dict["Price"] as? Double {
            self.price = price
        }
        
        if let listPrice = dict["ListPrice"] as? Double {
            self.listPrice = listPrice
        }
        
        if let bestInstallment = dict["BestInstallment"] as? [String:Any] {
            if let count = bestInstallment["Count"] as? Int,
                let value = bestInstallment["Value"] as? Double,
                let total = bestInstallment["Total"] as? Double {
                self.bestInstallment = BestInstallment(countInst: count, valueInst: value, totalInst: total)
            }
        }

    }
}
