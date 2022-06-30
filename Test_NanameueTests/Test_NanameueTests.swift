//
//  Test_NanameueTests.swift
//  Test_NanameueTests
//
//  Created by Zain ul abideen on 17/06/2022.
//

import XCTest
@testable import Test_Nanameue

class Test_NanameueTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testIsValidEmail() throws {
        let email = "zain@email.com"
        XCTAssertTrue(email.isValidEmail(), "Email is not valid")
        
    }
    
    func testTimeAgo() throws {
        var currentDate = Date()
        XCTAssertEqual(currentDate.timeAgoDisplay(), "0 seconds ago")
        
        currentDate.addTimeInterval(TimeInterval(-60))
        XCTAssertEqual(currentDate.timeAgoDisplay(), "1 minutes ago")
        
        currentDate.addTimeInterval(TimeInterval(60 * -60))
        XCTAssertEqual(currentDate.timeAgoDisplay(), "1 hours ago")
        
        currentDate.addTimeInterval(TimeInterval(24 * 60 * -60))
        XCTAssertEqual(currentDate.timeAgoDisplay(), "1 days ago")
        
        currentDate.addTimeInterval(TimeInterval(7 * 24 * 60 * -60))
        XCTAssertEqual(currentDate.timeAgoDisplay(), "1 weeks ago")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
