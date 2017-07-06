//
//  ProductViewModel.swift
//  Desafio Mobfiq
//
//  Created by Pro on 28/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import Foundation

class ProductViewModel {
    
    let product: Product
    
    var productPhotoUrlString: String?
    var productNameText: String?
    var previousPriceText: String?
    var currentPriceText: String?
    var installmentText: String?
    
    init(withProduct product: Product) {
        
        self.product = product
        
        self.productNameText = self.product.name
        
        if let sku = self.product.skus.first {
            // img
            if let imgUrlString = sku.images.first?.imageUrl {
                self.productPhotoUrlString = imgUrlString
            }
            
            // precos
            if let seller = sku.sellers.first {
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "pt_BR")
                
                if let listPrice = seller.listPrice {
                    self.previousPriceText = formatter.string(from: NSNumber(value: listPrice))
                }
                
                if let price = seller.price {
                    self.currentPriceText = formatter.string(from: NSNumber(value: price))
                }
                
                if let count = seller.bestInstallment?.countInst,
                    let value = seller.bestInstallment?.valueInst,
                    let formattedValue = formatter.string(from: NSNumber(value: value)) {
                    self.installmentText = String("\(count)x de \(formattedValue)")
                }
            }
        }
        
        
    
    }
}
