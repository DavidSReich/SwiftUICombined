//
//  UserDefaultsManagerTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 28/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class UserDefaultsManagerTests: XCTestCase {

    func testUserDefaultsManager() {
        let initialTags = "initial-Tags"
        let giphyAPIKey = "adsfinflsdfl023r"
        let maxNumberOfImages = 5
        let maxNumberOfLevels = 7

        let firstSettings = UserSettings(initialTags: initialTags,
                                         giphyAPIKey: giphyAPIKey,
                                         maxNumberOfImages: maxNumberOfImages,
                                         maxNumberOfLevels: maxNumberOfLevels)

        UserDefaultsManager.saveUserSettings(userSettings: firstSettings)
        let secondSettings = UserDefaultsManager.getUserSettings()

        XCTAssertEqual(firstSettings, secondSettings)
    }
}
