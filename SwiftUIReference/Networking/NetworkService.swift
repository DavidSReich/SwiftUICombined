//
//  NetworkService.swift
//  SwiftUIReference
//
//  Created by David S Reich on 6/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import RxSwift
import Combine

class NetworkService {
    func getDataPublisher(urlString: String,
                          mimeType: String,
                          not200Handler: HTTPURLResponseNot200? = nil) -> DataPublisher? {
        return SessionService.getDataPublisher(urlString: urlString, mimeType: mimeType, not200Handler: not200Handler)
    }
}
