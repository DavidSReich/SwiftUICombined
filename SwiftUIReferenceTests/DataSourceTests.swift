//
//  DataSourceTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 9/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class DataSourceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
