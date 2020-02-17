//
//  JSONNetworkService.swift
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

class JSONNetworkService {

    class func getJSON(urlString: String,
                       networkingType: UserSettings.NetworkingType,
                       completion: @escaping (Swift.Result<Data, ReferenceError>) -> Void) -> ReferenceError? {

        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot make URL")
            return .badURL
        }

        if networkingType == .alamoFire {
            _ = SessionManager.sessionManagerDataTask(urlString: urlString, mimeType: "application/json", completion: completion)
        } else {
            _ = URLSession.urlSessionDataTask(urlString: urlString, mimeType: "application/json", completion: completion)
        }

        return nil
    }

    class func getJSONObservable(urlString: String,
                                 networkingType: UserSettings.NetworkingType) -> Observable<Swift.Result<Data, ReferenceError>>? {

        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot make URL")
            return nil
        }

        var jsonObservable: Observable<Swift.Result<Data, ReferenceError>>?

        if networkingType == .alamoFire {
            jsonObservable = createAlamofireRequestObservable(urlString: urlString)
        } else {
            jsonObservable = createURLSessionDataTaskObservable(urlString: urlString)
        }

        return jsonObservable
    }

    private static func createURLSessionDataTaskObservable(urlString: String) -> Observable<Swift.Result<Data, ReferenceError>> {
        return Observable<Swift.Result<Data, ReferenceError>>.create({ (observer) -> Disposable in
            let dataTask = URLSession.urlSessionDataTask(urlString: urlString, mimeType: "application/json") { result in
                JSONNetworkService.handleResult(result: result, observer: observer)
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

    private static func createAlamofireRequestObservable(urlString: String) -> Observable<Swift.Result<Data, ReferenceError>> {
        return Observable<Swift.Result<Data, ReferenceError>>.create({ (observer) -> Disposable in
            let dataRequest = SessionManager.sessionManagerDataTask(urlString: urlString, mimeType: "application/json") { result in
                JSONNetworkService.handleResult(result: result, observer: observer)
            }

            return Disposables.create {
                dataRequest.cancel()
            }
        })
    }

    private static func handleResult(result: Swift.Result<Data, ReferenceError>,
                                     observer: AnyObserver<Swift.Result<Data, ReferenceError>>) {
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
