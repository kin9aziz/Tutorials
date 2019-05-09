//
//  DemoTests.swift
//  DemoTests
//
//  Created by Quang Tran on 2/20/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import XCTest
@testable import Demo

class DemoTests: XCTestCase {
    
    var viewController: ViewController!

    override func setUp() {
        self.viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSum2NumbersResult() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sum = viewController.sum2Numbers(num1: 1, num2: 2)
        XCTAssertEqual(sum, 3, "Sum of 1 and 2 is not equal 3")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
