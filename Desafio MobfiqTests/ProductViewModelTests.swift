//
//  ProductViewModelTests.swift
//  Desafio Mobfiq
//
//  Created by Pro on 28/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import XCTest

class ProductViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testListPriceBRLFormat() {
        
        let listPrice: Double? = 1199.835
        let formattedListPrice : String? = "R$1.199,84"
        
        let product = Product(name: nil, skus: [Sku(name: nil, sellers: [Seller(price: nil, listPrice: listPrice, bestInstallment: nil)] , images: [])])
        
        let productViewModel = ProductViewModel(withProduct: product)
        
        XCTAssertEqual(productViewModel.previousPriceText, formattedListPrice)
    }
    
    func testInstallmentTextFormat() {
        /*
         "BestInstallment": {
         "Count": 12,
         "Value": 99.98,
         "Total": 1199.83,
         "Rate": 0
         }
         */
        let count: Int? = 12
        let value: Double? = 99.98
        let total: Double? = 1199.83
        
        let formattedInstallment : String? = "12x de R$99,98"
        
        let bi = BestInstallment(countInst: count, valueInst: value, totalInst: total)
        let product = Product(name: nil, skus: [Sku(name: nil, sellers: [Seller(price: nil, listPrice: nil, bestInstallment: bi)], images: [])])
        
        let productViewModel = ProductViewModel(withProduct: product)
        
        XCTAssertEqual(productViewModel.installmentText, formattedInstallment)
    }
    
}
