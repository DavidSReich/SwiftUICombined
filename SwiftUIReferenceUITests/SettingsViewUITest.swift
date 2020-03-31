//
//  SettingsViewUITest.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 19/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

// swiftlint:disable line_length
// swiftlint:disable function_body_length

class SettingsViewUITest: XCTestCase {

    var app: XCUIApplication?

    override func setUp() {
        continueAfterFailure = false

        XCUIApplication().launch()

        app = XCUIApplication()

        addUIInterruptionMonitor(withDescription: "Alert") { alert in
            alert.buttons["Done"].tap()
            return true
        }
    }

    func testSettingsView() {
        guard let app = self.app else {
            XCTFail("couldn't find app")
            return
        }

        let settingsButton = app.navigationBars["Starting Images"].buttons["Settings"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5))
        settingsButton.tap()

        // navigation bar
        let selectTagsNavigationBar = app.navigationBars["Settings"]
        XCTAssertTrue(selectTagsNavigationBar.exists)
        XCTAssertTrue(selectTagsNavigationBar.buttons["Cancel"].exists)
        XCTAssertTrue(selectTagsNavigationBar.buttons["Reset"].exists)
        XCTAssertTrue(selectTagsNavigationBar.buttons["Apply"].exists)

        selectTagsNavigationBar.buttons["Reset"].tap()

        tableTest(tablesQuery: app.tables)
    }

    private func tableTest(tablesQuery: XCUIElementQuery) {
        // Registration section
        XCTAssertTrue(tablesQuery.staticTexts["Registration"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["GIPHY API Key"].exists)
        XCTAssertTrue(tablesQuery.cells.buttons["Get your GIPHY key here ..."].exists)
        XCTAssertTrue(tablesQuery.staticTexts["To use GIPHY in this app you need to create a GIPHY account, " +
            "and then create an App there to get an API Key."].exists)

        // Tags section
        XCTAssertTrue(tablesQuery.staticTexts["Tags"].exists)
        XCTAssertTrue(tablesQuery.staticTexts["Starting Tags"].exists)
        let tagsTextField = tablesQuery.cells.textFields["TagsTextField"]
        XCTAssertTrue(tagsTextField.exists)
        XCTAssertEqual(UserDefaultsManager.getInitialTags(), tagsTextField.value as? String)

        // RxSwift section
        XCTAssertTrue(tablesQuery.staticTexts["RxSwift"].exists)
        let useRxswiftSwitch = tablesQuery.cells/*@START_MENU_TOKEN@*/.switches["Use RxSwift"]/*[[".cells.switches[\"Use RxSwift\"]",".switches[\"Use RxSwift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(useRxswiftSwitch.exists)
        XCTAssertEqual("0", useRxswiftSwitch.value as? String)
        useRxswiftSwitch.tap()
        XCTAssertEqual("1", useRxswiftSwitch.value as? String)

        // Networking section
        XCTAssertTrue(tablesQuery.staticTexts["Networking"].exists)
        let alamofireButton = tablesQuery.cells/*@START_MENU_TOKEN@*/.buttons["Alamofire"]/*[[".cells",".segmentedControls.buttons[\"Alamofire\"]",".buttons[\"Alamofire\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(alamofireButton.exists)
        let urlsessionButton = tablesQuery.cells.buttons["URLSession"]
        XCTAssertTrue(urlsessionButton.exists)
        alamofireButton.tap()
        XCTAssertTrue(alamofireButton.isSelected)
        XCTAssertFalse(urlsessionButton.isSelected)
        urlsessionButton.tap()
        XCTAssertFalse(alamofireButton.isSelected)
        XCTAssertTrue(urlsessionButton.isSelected)

        // Limits section
        XCTAssertTrue(tablesQuery.staticTexts["Limits"].exists)

        let imageStepper = tablesQuery.cells/*@START_MENU_TOKEN@*/.otherElements["Max number of images"]/*[[".cells",".otherElements[\"Max number of images\"]",".otherElements[\"imageStepper\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/
        let levelStepper = tablesQuery.cells/*@START_MENU_TOKEN@*/.otherElements["Max number of levels"]/*[[".cells",".otherElements[\"Max number of levels\"]",".otherElements[\"levelStepper\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[1]]@END_MENU_TOKEN@*/
        XCTAssertTrue(imageStepper.exists)
        XCTAssertTrue(levelStepper.exists)

        XCTAssertEqual("7", imageStepper.value as? String)
        XCTAssertEqual("5", levelStepper.value as? String)

        tapStepper(stepper: imageStepper, increment: true)
        XCTAssertEqual("8", imageStepper.value as? String)
        tapStepper(stepper: imageStepper, increment: false)
        XCTAssertEqual("7", imageStepper.value as? String)

        tapStepper(stepper: levelStepper, increment: true)
        XCTAssertEqual("6", levelStepper.value as? String)
        tapStepper(stepper: levelStepper, increment: false)
        XCTAssertEqual("5", levelStepper.value as? String)
    }

    func tapStepper(stepper: XCUIElement, increment: Bool) {
        let cgVector = increment ? CGVector(dx: 0.75, dy: 0.5) : CGVector(dx: 0.25, dy: 0.5)

        let coordinate = stepper.coordinate(withNormalizedOffset: cgVector)
        coordinate.tap()
    }
}
