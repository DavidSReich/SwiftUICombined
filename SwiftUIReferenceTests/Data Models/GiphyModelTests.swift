//
//  GiphyModelTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 5/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class GiphyModelTests: XCTestCase {

    func testGiphyModel() {
        let jsonData = BaseTestUtilities.getGiphyModelData()

        let result: Result<GiphyModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let giphyModel):
            XCTAssertEqual(200, giphyModel.meta.status)
            XCTAssertEqual("OK", giphyModel.meta.msg)

            XCTAssertEqual(3, giphyModel.data.count)
            XCTAssertEqual("This is the title1", giphyModel.data[0].imageTitle)
            XCTAssertEqual("This is the title2", giphyModel.data[1].imageTitle)
            XCTAssertEqual("This is the title3", giphyModel.data[2].imageTitle)
        case .failure(let referenceError):
            XCTFail("Could not decode GiphyModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }

}
