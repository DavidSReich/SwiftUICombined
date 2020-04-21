//
//  HTTPUrlResponse+Validate.swift
//  SwiftUIReference
//
//  Created by David S Reich on 22/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine

protocol HTTPURLResponseNot200 {
    // handle non-200 response codes -- in case there's more info available
    // returns nil if no error mapping was performed
    func mapError(urlResponse: HTTPURLResponse, data: Data?) -> ReferenceError?
}

extension HTTPURLResponse {
    static func validateData(data: Data,
                             response: URLResponse,
                             mimeType: String?,
                             not200Handler: HTTPURLResponseNot200? = nil) -> DataPublisher {
        let result = validateDataError(data: data, response: response, mimeType: mimeType, not200Handler: not200Handler)

        switch result {
        case .success(let data):
            return Just(data)
                .setFailureType(to: ReferenceError.self)
                .eraseToAnyPublisher()
        case .failure(let referenceError):
            print("\(referenceError)")
            return Fail(error: referenceError).eraseToAnyPublisher()
        }
    }

    static func validateDataError(data: Data?,
                                  response: URLResponse?,
                                  mimeType: String?,
                                  not200Handler: HTTPURLResponseNot200? = nil) -> DataResult {

        guard let response = response else {
            print("No response.")
            return .failure(.noResponse)
        }

        if let mimeType = mimeType,
            let mime = response.mimeType,
            mime != mimeType {
            print("Response type not \(mimeType): \(String(describing: response.mimeType))")
            return .failure(.wrongMimeType(targeMimeType: mimeType, receivedMimeType: response.mimeType ?? "missing type"))
        }

        guard let urlResponse = response as? HTTPURLResponse else {
            print("Response not URLResponse: \(response).")
            return .failure(.notHttpURLResponse)
        }

        guard urlResponse.statusCode == 200 else {
            if let not200Handler = not200Handler {
                if let refError = not200Handler.mapError(urlResponse: urlResponse, data: data) {
                    return .failure(refError)
                }
            }

            print("Bad response statusCode = \(urlResponse.statusCode)")
            return .failure(.responseNot200(responseCode: urlResponse.statusCode))
        }

        guard let data = data, data.count > 0 else {
            print("No data.")
            return .failure(.noData)
        }

        return .success(data)
    }
}
