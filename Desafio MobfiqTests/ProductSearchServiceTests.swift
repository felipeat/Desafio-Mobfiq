//
//  ProductSearchServiceTests.swift
//  Desafio Mobfiq
//
//  Created by Pro on 29/06/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import XCTest

class ProductSearchServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testZeroCharQuerySearch() {
        
        let zeroCharquery : String = ""
        
        let service = ProductSearchService(RestApiClient())
        
        let expect = expectation(description: "POST \(ProductSearchService.endpoint)")
        
        service.query(zeroCharquery) { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let productsSearchResult = object as! [Product]
            
            XCTAssert(productsSearchResult.count > 0)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: service.lastRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testNonexistentProductQuerySearch() {
        let fooQuery : String = "Isso non ecziste"
        
        let service = ProductSearchService(RestApiClient())
        
        let expect = expectation(description: "POST \(ProductSearchService.endpoint)")
        
        service.query(fooQuery) { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let productsSearchResult = object as! [Product]
            
            XCTAssert(productsSearchResult.count == 0)
            
            expect.fulfill()
        }

        waitForExpectations(timeout: service.lastRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func testExistingProductQuerySearch() {
        let airfryerQuery : String = "Airfryer"
        
        let service = ProductSearchService(RestApiClient())
        
        let expect = expectation(description: "POST \(ProductSearchService.endpoint)")
        
        service.query(airfryerQuery) { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let productsSearchResult = object as! [Product]
            
            XCTAssert(productsSearchResult.count > 0)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: service.lastRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    /*
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
 */
    
}
