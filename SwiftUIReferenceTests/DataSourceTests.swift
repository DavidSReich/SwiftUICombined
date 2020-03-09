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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testDataSource() {
        let dataSource = DataSource(networkService: MockNetworkService())

        dataSource.getData(tagString: "data1",
                           urlString: "urlstring",
                           useRxSwift: true,
                           mimeType: "",
                           networkingType: .urlSession) { _ in
        }

        XCTAssertEqual(1, dataSource.resultsDepth)

        dataSource.getData(tagString: "data2",
                           urlString: "urlstring",
                           useRxSwift: true,
                           mimeType: "",
                           networkingType: .urlSession) { _ in
        }

        XCTAssertEqual(2, dataSource.resultsDepth)

        dataSource.getData(tagString: "data3",
                           urlString: "urlstring",
                           useRxSwift: true,
                           mimeType: "",
                           networkingType: .urlSession) { _ in
        }

        XCTAssertEqual(3, dataSource.resultsDepth)
        XCTAssertEqual("data3", dataSource.title)
        XCTAssertEqual("data2", dataSource.penultimateTitle)

        XCTAssertEqual(3, dataSource.currentResults?.count)

        XCTAssertNotNil(dataSource.currentResults)
        XCTAssertNotNil(dataSource.currentResults?[0])

        XCTAssertEqual(BaseTestUtilities.height, dataSource.currentResults?[0].imageModel.imageSize.height)
        XCTAssertEqual(BaseTestUtilities.width, dataSource.currentResults?[0].imageModel.imageSize.width)

        _ = dataSource.popResults()
        XCTAssertEqual(2, dataSource.resultsDepth)
        XCTAssertEqual("data2", dataSource.title)
        XCTAssertEqual("data1", dataSource.penultimateTitle)
    }
}

class MockNetworkService: NetworkService {
    override func getData(urlString: String,
                          useRxSwift: Bool,
                          mimeType: String,
                          networkingType: UserSettings.NetworkingType,
                          not200Handler: HTTPURLResponseNot200? = nil,
                          completion: @escaping (DataResult) -> Void) {
        completion(.success(BaseTestUtilities.getGiphyModelData()))
    }
}
