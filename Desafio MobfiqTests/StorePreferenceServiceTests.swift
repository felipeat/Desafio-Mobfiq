//
//  StorePreferenceServiceTests.swift
//  Desafio Mobfiq
//
//  Created by Pro on 07/07/17.
//  Copyright © 2017 Felipe Tavares. All rights reserved.
//

import XCTest

class StorePreferenceServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCategoryTreeFetch() {
        let service = StorePreferenceService(RestApiClient())
        
        let expect = expectation(description: "GET \(MobfiqServiceEndpoint.StorePreferenceCategoryTree.rawValue)")
        
        service.fetchCategoryTree() { (success, object) -> () in
            XCTAssertTrue(success)
            XCTAssertNotNil(object)
            
            let categoryTree = object as! CategoryTree
            
            XCTAssertNotNil(categoryTree)
            
            XCTAssert(categoryTree.categories.count > 0)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: service.lastRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
