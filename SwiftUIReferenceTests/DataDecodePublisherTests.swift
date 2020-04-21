//
//  DataDecodePublisherTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 19/4/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
import Combine

class DataDecodePublisherTests: XCTestCase {

    func testDataDecodePublisher() {
        let jsonData = BaseTestUtilities.getBasicImageData()

        let expectation = XCTestExpectation(description: "Testing data.decodeData() -> AnyPublisher ...")

        let decodeDataPublisher: AnyPublisher<BasicImageModel, ReferenceError> = jsonData.decodeData()

        decodeDataPublisher
            .sink(receiveCompletion: { fini in
                print(".sink() received the completion", String(describing: fini))
                switch fini {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("decodeDataPublisher failed")
                }
            }, receiveValue: { basicImageModel in
                XCTAssertEqual(BaseTestUtilities.largeHeightString, basicImageModel.height)
                XCTAssertEqual(BaseTestUtilities.largeWidthString, basicImageModel.width)
                XCTAssertEqual(BaseTestUtilities.largeImagePath, basicImageModel.url)
            })
            .cancel()

        XCTAssertNotNil(decodeDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }

    func testBadDataDecodePublisher() {
        let jsonData = Data("not a JSON data".utf8)

        let expectation = XCTestExpectation(description: "Testing bad data.decodeData() -> AnyPublisher ...")

        let decodeDataPublisher: AnyPublisher<BasicImageModel, ReferenceError> = jsonData.decodeData()

        decodeDataPublisher
            .sink(receiveCompletion: { fini in
                print(".sink() received the completion", String(describing: fini))
                switch fini {
                case .finished:
                    XCTFail("decodeDataPublisher succeeded -- should have failed")
                case .failure (let error):
                    XCTAssertEqual(ReferenceError.decodeJSON(reason: "").errorName, error.errorName)
                    expectation.fulfill()    //supposed to fail!
                }
            }, receiveValue: { _ in
                XCTFail("decodeDataPublisher received value -- should have failed")
            })
            .cancel()

        XCTAssertNotNil(decodeDataPublisher)
        wait(for: [expectation], timeout: 5.0)
    }
}
