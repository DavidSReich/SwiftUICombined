//
//  BasicImageModelTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 4/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class BasicImageModelTests: XCTestCase {

    func testBasicModel() {
        let jsonData = BaseTestUtilities.getBasicImageData()

        let result: Result<BasicImageModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let basicImageModel):
            XCTAssertEqual(BaseTestUtilities.largeHeightString, basicImageModel.height)
            XCTAssertEqual(BaseTestUtilities.largeWidthString, basicImageModel.width)
            XCTAssertEqual(BaseTestUtilities.largeImagePath, basicImageModel.url)
        case .failure(let referenceError):
            XCTFail("Could not decode BasicImageModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }
}
