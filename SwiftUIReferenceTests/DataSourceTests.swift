//
//  DataSourceTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 9/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest
@testable import SwiftUIReference

class DataSourceTests: XCTestCase {

    func testDataSource() {
        let dataSource = DataSource(networkService: MockNetworkService())

        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")
        dataSource.getData(tagString: "data1",
                           urlString: "urlstring",
                           mimeType: "") { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)

        XCTAssertEqual(1, dataSource.resultsDepth)

        let expectation2 = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")
        dataSource.getData(tagString: "data2",
                           urlString: "urlstring",
                           mimeType: "") { _ in
            expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 0.1)

        XCTAssertEqual(2, dataSource.resultsDepth)

        let expectation3 = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")
        dataSource.getData(tagString: "data3",
                           urlString: "urlstring",
                           mimeType: "") { _ in
            expectation3.fulfill()
        }
        wait(for: [expectation3], timeout: 0.1)

        XCTAssertEqual(3, dataSource.resultsDepth)
        XCTAssertEqual("data3", dataSource.title)
        XCTAssertEqual("data2", dataSource.penultimateTitle)

        XCTAssertEqual(3, dataSource.currentResults?.count)

        XCTAssertNotNil(dataSource.currentResults)
        XCTAssertNotNil(dataSource.currentResults?[0])

        XCTAssertEqual(240.0, dataSource.currentResults?[0].imageModel.imageSize.height)
        XCTAssertEqual(550.0, dataSource.currentResults?[0].imageModel.imageSize.width)

        _ = dataSource.popResults()
        XCTAssertEqual(2, dataSource.resultsDepth)
        XCTAssertEqual("data2", dataSource.title)
        XCTAssertEqual("data1", dataSource.penultimateTitle)
    }
}
