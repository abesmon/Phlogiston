//
//  PhlogistonUITests.swift
//  PhlogistonUITests
//
//  Created by Лысенко Алексей Димитриевич on 06/05/2019.
//  Copyright © 2019 Syrup Media Group. All rights reserved.
//

import XCTest

class PhlogistonUITests: XCTestCase {
    private var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testScreenshots() {
        snapshot("0-empty")

        let canvas = XCUIApplication().otherElements["canvas"]
        canvas.swipeUp()
        canvas.swipeRight()
        snapshot("1-canvas-with-cross")
        
        let toolbarButtons = app.toolbars.buttons
        toolbarButtons.element(boundBy: 1).tap()
        snapshot("2-toolbar-open")
    }
}
