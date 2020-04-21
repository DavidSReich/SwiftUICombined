//
//  SessionService.swift
//  GIPHYTags
//
//  Created by David S Reich on 9/12/19.
//  Copyright © 2017 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine

class SessionService {
    class func getDataPublisher(urlString: String,
                                mimeType: String,
                                not200Handler: HTTPURLResponseNot200? = nil) -> DataPublisher? {

        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot make URL")
            // .badURL
            return nil
        }

        guard let url = URL(string: urlString) else {
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
