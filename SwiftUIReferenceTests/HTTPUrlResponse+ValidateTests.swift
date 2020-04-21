//
//  HTTPUrlResponse+ValidateTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 26/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine
import XCTest

class HTTPUrlResponseValidateTests: XCTestCase {

    private var goodJSONData = Data()
    private var goodHttpUrlResponse = HTTPURLResponse()
    private var bad401HttpUrlResponse = HTTPURLResponse()
    private var bad403HttpUrlResponse = HTTPURLResponse()
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

        if let bad401HttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 401, httpVersion: nil, headerFields: nil) {
            self.bad401HttpUrlResponse = bad401HttpUrlResponse
        } else {
            XCTFail("Couldn't create bad401HttpUrlResponse!!")
        }

        if let bad403HttpUrlResponse = HTTPURLResponse(url: dummyURL!, statusCode: 403, httpVersion: nil, headerFields: nil) {
            self.bad403HttpUrlResponse = bad403HttpUrlResponse
        } else {
            XCTFail("Couldn't create bad403HttpUrlResponse!!")
        }

        self.goodUrlResponse = URLResponse(url: dummyURL!, mimeType: dummyMimeType, expectedContentLength: 1000, textEncodingName: nil)
    }

    func testGoodData() {
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: goodJSONData, response: goodHttpUrlResponse, mimeType: nil)

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("validateDataPublisher failed")
                }
            }, receiveValue: { data in
                XCTAssertEqual(self.goodJSONData, data)
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }

    func testUrlResponse() {
        // succeed all the way until notHttpURLResponse
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: goodJSONData, response: goodUrlResponse, mimeType: dummyMimeType)

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    XCTFail("urlResponse should fail with notHttpURLResponse.  But it didn't fail.")
                case .failure(let referenceError):
                    if case ReferenceError.notHttpURLResponse = referenceError {
                        //supposed to fail at this point because a URLRepsonse cannot become a HTTPUrlResponse
                        expectation.fulfill()
                    } else {
                        XCTFail("urlResponse should fail with notHttpURLResponse.  Instead failed with \(referenceError).")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Got value -- but, urlResponse should fail with notHttpURLResponse and not receiveValue.")
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }

    func testWrongMime() {
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: goodJSONData, response: goodUrlResponse, mimeType: "wrongMime")

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    XCTFail("urlResponse should fail with wrongMimeType.  But it didn't fail.")
                case .failure(let referenceError):
                    if case ReferenceError.wrongMimeType = referenceError {
                        //supposed to fail at this point
                        expectation.fulfill()
                    } else {
                        XCTFail("urlResponse should fail with wrongMimeType.  Instead failed with \(referenceError).")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Got value -- but, urlResponse should fail with wrongMimeType and not receiveValue.")
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }

    func test401HttpUrlResponseCode() {
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: BaseTestUtilities.getMessageModelData(),
                                         response: bad401HttpUrlResponse,
                                         mimeType: nil,
                                         not200Handler: self)

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    XCTFail("urlResponse should fail with apiNotHappy.  But it didn't fail.")
                case .failure(let referenceError):
                    if case ReferenceError.apiNotHappy(message: let message) = referenceError {
                        XCTAssertEqual("Invalid authentication credentials", message)
                        expectation.fulfill()
                    } else {
                        XCTFail("urlResponse should fail with apiNotHappy error.  Instead failed with \(referenceError).")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Got value -- but, urlResponse should fail with apiNotHappy and not receiveValue.")
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }

    func test403HttpUrlResponseCode() {
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: BaseTestUtilities.getMessageModelData(),
                                         response: bad403HttpUrlResponse,
                                         mimeType: nil,
                                         not200Handler: self)

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    XCTFail("urlResponse should fail with apiNotHappy.  But it didn't fail.")
                case .failure(let referenceError):
                    if case ReferenceError.apiNotHappy(message: let message) = referenceError {
                        XCTAssertEqual("API Key might be incorrect.  Go to Settings to check it.", message)
                        expectation.fulfill()
                    } else {
                        XCTFail("urlResponse should fail with apiNotHappy error.  Instead failed with \(referenceError).")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Got value -- but, urlResponse should fail with apiNotHappy and not receiveValue.")
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }

    func testBadResponseCode() {
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: goodJSONData, response: badHttpUrlResponse, mimeType: nil)

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    XCTFail("urlResponse should fail with responseNot200.  But it didn't fail.")
                case .failure(let referenceError):
                    if case ReferenceError.responseNot200(responseCode: let responseCode) = referenceError {
                        XCTAssertEqual(500, responseCode)
                        expectation.fulfill()
                        //supposed to fail at this point because a we set a responseCode == 500 here.
                    } else {
                        XCTFail("urlResponse should fail with responseNot200.500 error.  Instead failed with \(referenceError).")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Got value -- but, urlResponse should fail with responseNot200.500 and not receiveValue.")
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }

    func testBadData() {
        let expectation = XCTestExpectation(description: "Testing HTTPURLResponse.validateData() -> AnyPublisher ...")

        // data with count zero
        let validateDataPublisher: DataPublisher =
            HTTPURLResponse.validateData(data: Data(), response: goodHttpUrlResponse, mimeType: nil)

        validateDataPublisher
            .sink(receiveCompletion: { fini in
                switch fini {
                case .finished:
                    XCTFail("urlResponse should fail with noData.  But it didn't fail.")
                case .failure(let referenceError):
                    if case ReferenceError.noData = referenceError {
                        expectation.fulfill()
                        //supposed to fail at this point because a we set empty data.
                    } else {
                        XCTFail("urlResponse should fail with noData error.  Instead failed with \(referenceError).")
                    }
                }
            }, receiveValue: { _ in
                XCTFail("Got value -- but, urlResponse should fail with noData and not receiveValue.")
            })
            .cancel()

        XCTAssertNotNil(validateDataPublisher)
        wait(for: [expectation], timeout: 0.1)
    }
}

extension HTTPUrlResponseValidateTests: HTTPURLResponseNot200 {
    // handle non-200 response codes -- in case there's more info available
    // returns nil if no error mapping was performed
    internal func mapError(urlResponse: HTTPURLResponse, data: Data?) -> ReferenceError? {
        if [401, 403].contains(urlResponse.statusCode), let data = data {
            let result: Result<MessageModel, ReferenceError> = data.decodeData()

            if case .success(let messageModel) = result {
                //print("403 error: \(messageModel.message)")
                var message = messageModel.message
                if urlResponse.statusCode == 403 {
                    message = "API Key might be incorrect.  Go to Settings to check it."
                }

                return .apiNotHappy(message: message)
            }
        }

        return nil
    }
}
