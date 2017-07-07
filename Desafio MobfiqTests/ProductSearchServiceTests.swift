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
        
        let expect = expectation(description: "POST \(MobfiqServiceEndpoint.SearchCriteria.rawValue)")
        
        service.query(withString:zeroCharquery, maxResults: 10, offset: 0) { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let searchResult = object as! SearchResult
            
            XCTAssert(searchResult.total! > 0)
            XCTAssert(searchResult.products.count > 0)
            
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
        
        let expect = expectation(description: "POST \(MobfiqServiceEndpoint.SearchCriteria.rawValue)")
        
        service.query(withString:fooQuery, maxResults: 10, offset: 0) { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let searchResult = object as! SearchResult
            
            XCTAssert(searchResult.total! == 0)
            XCTAssert(searchResult.products.count == 0)
            
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
        
        let expect = expectation(description: "POST \(MobfiqServiceEndpoint.SearchCriteria.rawValue)")
        
        service.query(withString:airfryerQuery, maxResults: 10, offset: 0) { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let searchResult = object as! SearchResult
            
            XCTAssert(searchResult.total! > 0)
            XCTAssert(searchResult.products.count > 0)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: service.lastRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testQuerySearchWithCriteriaFromCategory() {
        
        let apiClient = RestApiClient()
        
        let request = NSMutableURLRequest(url: URL(string: "https://desafio.mobfiq.com.br/StorePreference/CategoryTree")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let expect = expectation(description: "GET \(request.url!.absoluteString)")
        
        apiClient.get(request: request as NSMutableURLRequest) { (success, object) in
            
            let jsonString = object as! String
            
            
            if let data = jsonString.data(using: .utf8),
                let jsonObject = try! JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                let categories = jsonObject["Categories"] as! [[String : Any]]
                let redirect = categories[0]["Redirect"] as! [String : Any]
                let searchCriteria = redirect["SearchCriteria"] as! [String : Any]
                
                let service = ProductSearchService(RestApiClient())
                
                service.query(withSearchCriteria: searchCriteria) { (success, object) -> () in
                    XCTAssertTrue(success)
                    XCTAssertNotNil(object)
                    
                    let searchResult = object as! SearchResult
                    
                    XCTAssert(searchResult.total! > 0)
                    XCTAssert(searchResult.products.count > 0)
                    
                    expect.fulfill()
                }
            }
            
        }

        waitForExpectations(timeout: request.timeoutInterval * 2) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
