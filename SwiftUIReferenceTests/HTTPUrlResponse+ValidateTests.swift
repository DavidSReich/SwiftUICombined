//
//  HTTPUrlResponse+ValidateTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 26/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import XCTest

class HTTPUrlResponseValidateTests: XCTestCase {

    private var goodJSONData = Data()
    private var goodHttpUrlResponse = HTTPURLResponse()
    private var badHttpUrlResponse = HTTPURLResponse()
    private var goodUrlResponse = URLResponse()
    private var error: ReferenceError?
    private var dummyURL = URL(string: "https://a.b.com")
    private var dummyMimeType = "dummyMimeType"

    override func setUp() {
        goodJSONData = BaseTestUtilities.getGiphyModelData()

        if let goodHttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 200, httpVersion: nil, headerFields: nil) {
            self.goodHttpUrlResponse = goodHttpUrlResponse
        } else {
            XCTFail("Couldn't create goodHTTPUrlResponse!!")
        }

        if let badHttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 500, httpVersion: nil, headerFields: nil) {
            self.badHttpUrlResponse = badHttpUrlResponse
        } else {
            XCTFail("Couldn't create badHTTPUrlResponse!!")
        }

        self.goodUrlResponse = URLResponse(url: dummyURL!, mimeType: dummyMimeType, expectedContentLength: 1000, textEncodingName: nil)
    }

    func testGoodData() {
        HTTPURLResponse.validateData(data: goodJSONData, response: goodHttpUrlResponse, error: nil, mimeType: nil) { result in
            switch result {
            case .success:
                //supposed to succeed ... data is tested by the caller of this in a completion handler.
                return
            case .failure(let referenceError):
                XCTFail("goodHttpUrlResponse should not fail.  Instead failed with \(referenceError).")
            }
        }
    }

    func testErrors() {
        // basic Error
        // swiftlint:disable line_length
        HTTPURLResponse.validateData(data: goodJSONData, response: goodHttpUrlResponse, error: ReferenceError.noData, mimeType: nil) { result in
            switch result {
            case .success:
                XCTFail("Should fail with dataTask error.  But it didn't fail.")
                return
            case .failure(let referenceError):
                if case ReferenceError.dataTask(error: let innerError) = referenceError {
                    if case ReferenceError.noData = innerError {
                        //supposed to fail at this point because a we set a noData error here
                        return
                    }
                }
                XCTFail("urlResponse should fail with dataTask.noData error.  Instead failed with \(referenceError).")
            }
        }

        // no urlResponse
        HTTPURLResponse.validateData(data: goodJSONData, response: nil, error: nil, mimeType: nil) { result in
            switch result {
            case .success:
                XCTFail("Should fail with noResponse error.  But it didn't fail.")
                return
            case .failure(let referenceError):
                if case ReferenceError.noResponse = referenceError {
                    //supposed to fail at this point because a we did not provide a response here
                    return
                }
                XCTFail("urlResponse should fail with noResponse error.  Instead failed with \(referenceError).")
            }
        }
    }

    func testUrlResponse() {
        // succeed all the way until notHttpURLResponse
        HTTPURLResponse.validateData(data: goodJSONData, response: goodUrlResponse, error: nil, mimeType: dummyMimeType) { result in
            switch result {
            case .success:
                XCTFail("urlResponse should fail with notHttpURLResponse.  But it didn't fail.")
            case .failure(let referenceError):
                if case ReferenceError.notHttpURLResponse = referenceError {
                    //supposed to fail at this point because a URLRepsonse cannot become a HTTPUrlResponse
                    return
                }
                XCTFail("urlResponse should fail with notHttpURLResponse.  Instead failed with \(referenceError).")
            }
        }

        // wrong mime
        HTTPURLResponse.validateData(data: goodJSONData, response: goodUrlResponse, error: nil, mimeType: "wrongMime") { result in
            switch result {
            case .success:
                XCTFail("urlResponse should fail with wrongMimeType.  But it didn't fail.")
            case .failure(let referenceError):
                if case ReferenceError.wrongMimeType = referenceError {
                    //supposed to fail at this point because a we set "wrongMime" here
                    return
                }
                XCTFail("urlResponse should fail with wrongMimeType.  Instead failed with \(referenceError).")
            }
        }
    }

    func testBadResponseCode() {
        HTTPURLResponse.validateData(data: goodJSONData, response: badHttpUrlResponse, error: nil, mimeType: nil) { result in
            switch result {
            case .success:
                XCTFail("Should fail with noResponse error.  But it didn't fail.")
                return
            case .failure(let referenceError):
                if case ReferenceError.responseNot200(responseCode: let responseCode) = referenceError {
                    if responseCode == 500 {
                        //supposed to fail at this point because a we set a responseCode == 500 here.
                        return
                    }
                }
                XCTFail("urlResponse should fail with responseNot200.500 error.  Instead failed with \(referenceError).")
            }
        }
    }

    func testBadData() {
        // data with count zero
        HTTPURLResponse.validateData(data: Data(), response: goodHttpUrlResponse, error: nil, mimeType: nil) { result in
            switch result {
            case .success:
                XCTFail("urlResponse should fail with noData.  But it didn't fail.")
            case .failure(let referenceError):
                if case ReferenceError.noData = referenceError {
                    //supposed to fail at this point because we set empty data.
                    return
                }
                XCTFail("urlResponse should fail with noData.  Instead failed with \(referenceError).")
            }
        }

        // missing data
        HTTPURLResponse.validateData(data: nil, response: goodHttpUrlResponse, error: nil, mimeType: nil) { result in
            switch result {
            case .success:
                XCTFail("urlResponse should fail with noData.  But it didn't fail.")
            case .failure(let referenceError):
                if case ReferenceError.noData = referenceError {
                    //supposed to fail at this point because we set no data.
                    return
                }
                XCTFail("urlResponse should fail with noData.  Instead failed with \(referenceError).")
            }
        }
    }
}
