//
//  ResultsStackTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 4/2/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class ResultsStackTests: XCTestCase {

    func testResultsStack() {
        let jsonData = BaseTestUtilities.getGiphyModelData()

        let result: Result<GiphyModel, ReferenceError> = jsonData.decodeData()
        // if decode fails it will be caught in another test.

        let resultsStack = ResultsStack()

        if case .success(let giphyModel) = result {
            var imageDataModels = ImageDataModel.getWrappedImageModels(from: giphyModel)

            resultsStack.pushResults(tagsString: "three images", images: imageDataModels)
            _ = imageDataModels.popLast()
            resultsStack.pushResults(tagsString: "two images", images: imageDataModels)
            _ = imageDataModels.popLast()
            resultsStack.pushResults(tagsString: "one image", images: imageDataModels)

            var resultsTest = resultsStack.getLast()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("one image", resultsTest?.tagsString)
            XCTAssertEqual(1, resultsTest?.images.count)

            resultsTest = resultsStack.popResults()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("one image", resultsTest?.tagsString)
            XCTAssertEqual(1, resultsTest?.images.count)

            resultsTest = resultsStack.popResults()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("two images", resultsTest?.tagsString)
            XCTAssertEqual(2, resultsTest?.images.count)

            resultsTest = resultsStack.popResults()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("three images", resultsTest?.tagsString)
            XCTAssertEqual(3, resultsTest?.images.count)

            resultsTest = resultsStack.getLast()
            XCTAssertNil(resultsTest)
        }
    }
}
