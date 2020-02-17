//
//  ImageDataModelTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 4/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class ImageDataModelTests: XCTestCase {

    func testImageDataModel() {
        let jsonData = BaseTestUtilities.getImageDataModelData()

        let result: Result<ImageDataModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let imageDataModel):
            XCTAssertEqual("This is the title", imageDataModel.imageTitle)
            XCTAssertEqual(["abc", "efg", "hij"], imageDataModel.tags)

            XCTAssertEqual(BaseTestUtilities.largeHeight, imageDataModel.largeImageSize.height)
            XCTAssertEqual(BaseTestUtilities.largeWidth, imageDataModel.largeImageSize.width)
            XCTAssertEqual(BaseTestUtilities.largeImagePath, imageDataModel.largeImagePath)

            XCTAssertEqual(BaseTestUtilities.height, imageDataModel.imageSize.height)
            XCTAssertEqual(BaseTestUtilities.width, imageDataModel.imageSize.width)
            XCTAssertEqual(BaseTestUtilities.imagePath, imageDataModel.imagePath)
        case .failure(let referenceError):
            XCTFail("Could not decode ImageDataModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }

}
