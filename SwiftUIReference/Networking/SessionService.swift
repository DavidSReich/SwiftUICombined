//
//  SessionService.swift
//  GIPHYTags
//
//  Created by David S Reich on 9/12/19.
//  Copyright © 2017 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

// This is overly complicated
// but it is this way to illustrate all 4 combinations of RxSwift|NoRxSwift and UrlSession|Alamofire

// This might NOT be thread-safe or re-entrant?
class SessionService {

    typealias ObservableData = Observable<DataResult>

    class func getData(urlString: String,
                       mimeType: String,
                       networkingType: UserSettings.NetworkingType,
                       not200Handler: HTTPURLResponseNot200? = nil,
                       completion: @escaping (DataResult) -> Void) -> ReferenceError? {

        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot make URL")
            return .badURL
        }

        if networkingType == .alamoFire {
            _ = SessionManager.sessionManagerDataTask(urlString: urlString,
                                                      mimeType: mimeType,
                                                      not200Handler: not200Handler,
                                                      completion: completion)
        } else {
            _ = URLSession.urlSessionDataTask(urlString: urlString,
                                              mimeType: mimeType,
                                              not200Handler: not200Handler,
                                              completion: completion)
        }

        return nil
    }

    class func getDataObservable(urlString: String,
                                 mimeType: String,
                                 networkingType: UserSettings.NetworkingType,
                                 not200Handler: HTTPURLResponseNot200? = nil) -> ObservableData? {

        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot make URL")
            return nil
        }

        var dataObservable: ObservableData?

        if networkingType == .alamoFire {
            dataObservable = createAlamofireObservable(urlString: urlString, mimeType: mimeType, not200Handler: not200Handler)
        } else {
            dataObservable = createURLSessionDataTaskObservable(urlString: urlString, mimeType: mimeType, not200Handler: not200Handler)
        }

        return dataObservable
    }

    private static func createURLSessionDataTaskObservable(urlString: String,
                                                           mimeType: String,
                                                           not200Handler: HTTPURLResponseNot200? = nil) -> ObservableData {
        return ObservableData.create({ (observer) -> Disposable in
            let dataTask = URLSession.urlSessionDataTask(urlString: urlString,
                                                         mimeType: mimeType,
                                                         not200Handler: not200Handler) { result in
                SessionService.handleResult(result: result, observer: observer)
            }

            if let dataTask = dataTask {
                dataTask.resume()
            }

            return Disposables.create(with: {
                //Cancel the connection if disposed
                if let dataTask = dataTask {
                    dataTask.cancel()
                }
            })
        })
    }

    private static func createAlamofireObservable(urlString: String,
                                                  mimeType: String,
                                                  not200Handler: HTTPURLResponseNot200? = nil) -> ObservableData {
        return ObservableData.create({ (observer) -> Disposable in
            let dataRequest = SessionManager.sessionManagerDataTask(urlString: urlString,
                                                                    mimeType: mimeType,
                                                                    not200Handler: not200Handler) { result in
                SessionService.handleResult(result: result, observer: observer)
            }

            return Disposables.create {
                dataRequest.cancel()
            }
        })
    }

    private static func handleResult(result: DataResult,
                                     observer: AnyObserver<DataResult>) {
        switch result {
        case .success:
            observer.onNext(result)
            observer.onCompleted()
        case .failure(let referenceError):
            observer.onError(referenceError)
            print("\(referenceError)")
        }
    }

}
