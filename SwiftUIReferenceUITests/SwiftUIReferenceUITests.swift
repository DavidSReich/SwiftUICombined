//
//  SwiftUIReferenceUITests.swift
//  SwiftUIReferenceUITests
//
//  Created by David S Reich on 8/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class SwiftUIReferenceUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()

        let navBar = app.navigationBars["Starting Images"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: navBar, handler: nil)
        waitForExpectations(timeout: 8, handler: nil)
    }

    func testSwiftUIReference() {
        // UI tests must launch the application that they test.

        let settingsButton = app.navigationBars["Starting Images"].buttons["Settings"]

        settingsButton.tap()

        let resetButton = app.buttons["Reset"]
        XCTAssertNotNil(resetButton)
        resetButton.tap()

        let startingTags = app.tables.otherElements["Starting Tags\nweather"]
        XCTAssertNotNil(startingTags)

        let startingTag = app.tables.otherElements["weather"]
        XCTAssertNotNil(startingTag)

        let maxOfImages5Element = app.tables.otherElements["Max # of images\n5"]
        XCTAssertNotNil(maxOfImages5Element)

        let imageStepper = app.otherElements["imageStepper"]
        XCTAssertNotNil(imageStepper)

        let plusCoordinate = imageStepper.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        plusCoordinate.tap()
        plusCoordinate.tap()

        let maxOfImages7Element = app.tables.otherElements["Max # of images\n7"]
        XCTAssertNotNil(maxOfImages7Element)
    }
}
