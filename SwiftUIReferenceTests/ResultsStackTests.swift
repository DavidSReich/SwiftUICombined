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

            resultsStack.saveResults(index: 2, tagsString: "three images", images: imageDataModels)
            _ = imageDataModels.popLast()
            resultsStack.saveResults(index: 4, tagsString: "two images", images: imageDataModels)
            _ = imageDataModels.popLast()
            resultsStack.saveResults(index: 6, tagsString: "one image", images: imageDataModels)

            let results3 = resultsStack.getResults(index: 2)
            let results2 = resultsStack.getResults(index: 4)
            let results1 = resultsStack.getResults(index: 6)

            XCTAssertNotNil(results3)
            XCTAssertNotNil(results2)
            XCTAssertNotNil(results1)

            XCTAssertEqual("three images", results3?.tagsString)
            XCTAssertEqual(3, results3?.images.count)
            XCTAssertEqual("two images", results2?.tagsString)
            XCTAssertEqual(2, results2?.images.count)
            XCTAssertEqual("one image", results1?.tagsString)
            XCTAssertEqual(1, results1?.images.count)
        }
    }

}
