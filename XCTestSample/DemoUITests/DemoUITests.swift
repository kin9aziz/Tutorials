//
//  DemoUITests.swift
//  DemoUITests
//
//  Created by Quang Tran on 2/20/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import XCTest
import Photos

class DemoUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHelloWorldMessageHasBeenShown() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.buttons["Show Message"].tap()
        let messageLabel = app.staticTexts["Hello World"]
        XCTAssertTrue(messageLabel.exists)

        // Capture screenshot at current state and keep it in test reports
        XCTContext.runActivity(named: "Capture screenshot") { activity in
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.lifetime = .keepAlways // Keep even if test succeeds, else xcode deletes it.
            activity.add(attachment)
        }
    }

}
