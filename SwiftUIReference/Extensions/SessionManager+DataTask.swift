//
//  SessionManager+DataTask.swift
//  SwiftUIReference
//
//  Created by David S Reich on 22/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Alamofire

extension SessionManager {
    class func sessionManagerDataTask(urlString: String,
                                      mimeType: String,
                                      not200Handler: HTTPURLResponseNot200? = nil,
                                      completion: @escaping (DataResult) -> Void) -> DataRequest {

        let dataRequest = SessionManager.default.request(urlString).response { response in
            HTTPURLResponse.validateData(data: response.data,
                                         response: response.response,
                                         error: response.error,
                                         mimeType: mimeType,
                                         not200Handler: not200Handler,
                                         completion: completion)
        }

        return dataRequest
    }
}
