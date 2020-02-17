//
//  HTTPUrlResponse+Validate.swift
//  SwiftUIReference
//
//  Created by David S Reich on 22/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    static func validateData(data: Data?,
                             response: URLResponse?,
                             error: Error?,
                             mimeType: String?,
                             completion: @escaping (Result<Data, ReferenceError>) -> Void) {
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
            if [401, 403].contains(urlResponse.statusCode), let data = data {
                let result: Result<MessageModel, ReferenceError> = data.decodeData()

                if case .success(let messageModel) = result {
                    //print("403 error: \(messageModel.message)")
                    var message = messageModel.message
                    if urlResponse.statusCode == 403 {
                        message = "API Key might be incorrect.  Go to Settings to check it."
                    }
                    completion(.failure(.apiNotHappy(message: message)))
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
