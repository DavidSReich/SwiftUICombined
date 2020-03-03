//
//  Data+Decode.swift
//  SwiftUIReference
//
//  Created by David S Reich on 5/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

public typealias DataResult = Result<Data, ReferenceError>

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
}
