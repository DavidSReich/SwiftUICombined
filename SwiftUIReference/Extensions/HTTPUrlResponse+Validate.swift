//
//  HTTPUrlResponse+Validate.swift
//  SwiftUIReference
//
//  Created by David S Reich on 22/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

protocol HTTPURLResponseNot200 {
    // handle non-200 response codes -- in case there's more info available
    // returns true if it "consumes" the case
    func responseHandler(urlResponse: HTTPURLResponse, data: Data?, completion: @escaping (DataResult) -> Void) -> Bool
}

extension HTTPURLResponse {
    static func validateData(data: Data?,
                             response: URLResponse?,
                             error: Error?,
                             mimeType: String?,
                             not200Handler: HTTPURLResponseNot200? = nil,
                             completion: @escaping (DataResult) -> Void) {
        if let error = error {
            print("DataTask error: \(error)")
            completion(.failure(.dataTask(error: error)))
            return
        }

        guard let response = response else {
            print("No response.")
            completion(.failure(.noResponse))
            return
        }

        if let mimeType = mimeType,
            let mime = response.mimeType,
                mime != mimeType {
            print("Response type not \(mimeType): \(String(describing: response.mimeType))")
            completion(.failure(.wrongMimeType(targeMimeType: mimeType, receivedMimeType: response.mimeType ?? "missing type")))
            return
        }

        guard let urlResponse = response as? HTTPURLResponse else {
            print("Response not URLResponse: \(response).")
            completion(.failure(.notHttpURLResponse))
            return
        }

        guard urlResponse.statusCode == 200 else {
            if let not200Handler = not200Handler {
                if not200Handler.responseHandler(urlResponse: urlResponse, data: data, completion: completion) {
                    return
                }
            }

            print("Bad response statusCode = \(urlResponse.statusCode)")
            completion(.failure(.responseNot200(responseCode: urlResponse.statusCode)))
            return
        }

        guard let data = data, data.count > 0 else {
            print("No data.")
            completion(.failure(.noData))
            return
        }

        DispatchQueue.main.async {
            completion(.success(data))
        }
    }
}
