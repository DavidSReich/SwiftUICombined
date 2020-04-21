//
//  Data+Decode.swift
//  SwiftUIReference
//
//  Created by David S Reich on 5/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine

extension Data {
    func decodeData<T: Decodable>() -> Result<T, ReferenceError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let result = try decoder.decode(T.self, from: self)
            //print("\(T.Type.self):\n   \(result)")
            return .success(result)
        } catch {
            print("\(T.Type.self) decode threw error: \(error)")
            return .failure(.decodeJSON(reason: "\(error)"))
        }
    }

    func decodeData<T: Decodable>() -> AnyPublisher<T, ReferenceError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return Just(self)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .decodeJSON(reason: "\(error)")
            }
            .eraseToAnyPublisher()
    }

    // handy for debugging
    func prettyPrintData() {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) {
            if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                if let detailString = String(data: prettyPrintedData, encoding: .utf8) {
                    print("json:\n\(detailString)")
                }
            }
        }
    }
}
