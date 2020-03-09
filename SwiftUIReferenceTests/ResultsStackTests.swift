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

        let resultsStack = ResultsStack<ImageDataModelProtocolWrapper>()

        if case .success(let giphyModel) = result {
            var imageDataModels = ImageDataModel.getWrappedImageModels(from: giphyModel)

            resultsStack.pushResults(title: "three images", values: imageDataModels)
            _ = imageDataModels.popLast()
            resultsStack.pushResults(title: "two images", values: imageDataModels)
            _ = imageDataModels.popLast()
            resultsStack.pushResults(title: "one image", values: imageDataModels)

            var resultsTest = resultsStack.getLast()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("one image", resultsTest?.title)
            XCTAssertEqual(1, resultsTest?.values.count)

            resultsTest = resultsStack.popResults()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("two images", resultsTest?.title)
            XCTAssertEqual(2, resultsTest?.values.count)

            resultsTest = resultsStack.popResults()
            XCTAssertNotNil(resultsTest)
            XCTAssertEqual("three images", resultsTest?.title)
            XCTAssertEqual(3, resultsTest?.values.count)

            resultsTest = resultsStack.popResults()
            XCTAssertNil(resultsTest)
        }
    }
}
