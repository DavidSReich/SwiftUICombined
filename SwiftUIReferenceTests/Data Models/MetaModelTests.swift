//
//  MetaModelTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 4/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class MetaModelTests: XCTestCase {

    func testMetaModel() {
        let jsonData = BaseTestUtilities.getMetaModelData()

        let result: Result<MetaModel, ReferenceError> = jsonData.decodeData()

        switch result {
        case .success(let metaModel):
            XCTAssertEqual(200, metaModel.status)
            XCTAssertEqual("OK", metaModel.msg)
        case .failure(let referenceError):
            XCTFail("Could not decode MetaModel data. - \(String(describing: referenceError.errorDescription))")
        }
    }

}
