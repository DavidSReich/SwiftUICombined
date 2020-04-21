//
//  NetworkService.swift
//  SwiftUIReference
//
//  Created by David S Reich on 6/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine

public typealias DataPublisher = AnyPublisher<Data, ReferenceError>

class NetworkService {
    func getDataPublisher(urlString: String,
                          mimeType: String,
                          not200Handler: HTTPURLResponseNot200? = nil) -> DataPublisher? {

        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) else {
                print("Cannot make URL")
                // .badURL
                return nil
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                .dataTask(error: error)
        }
        .flatMap(maxPublishers: .max(1)) { result in
            return HTTPURLResponse.validateData(data: result.data, response: result.response, mimeType: mimeType)
        }
        .eraseToAnyPublisher()
    }
}
