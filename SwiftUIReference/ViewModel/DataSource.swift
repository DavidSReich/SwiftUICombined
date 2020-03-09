//
//  DataSource.swift
//  SwiftUIReference
//
//  Created by David S Reich on 7/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

class DataSource {
    let networkService: NetworkService

    private var resultsStack = ResultsStack<ImageDataModelProtocolWrapper>()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getData(tagString: String,
                 urlString: String,
                 useRxSwift: Bool,
                 mimeType: String,
                 networkingType: UserSettings.NetworkingType,
                 completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        networkService.getData(urlString: urlString,
                               useRxSwift: useRxSwift,
                               mimeType: mimeType,
                               networkingType: networkingType,
                               not200Handler: self) { result in
            switch result {
            case .success(let data):
                self.handleData(tagString: tagString, data: data, completion: completion)
            case .failure(let referenceError):
                completion(referenceError)
            }
        }
    }

    private func handleData(tagString: String, data: Data, completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
//        data.prettyPrintData()

        let result: Result<GiphyModel, ReferenceError> = data.decodeData()
        switch result {
        case .success(let giphyModel):
            resultsStack.pushResults(title: tagString, values: ImageDataModel.getWrappedImageModels(from: giphyModel))
            completion(nil)
        case .failure(let referenceError):
            completion(referenceError)
        }
    }

    var resultsDepth: Int {
        resultsStack.resultsCount
    }

    func clearAllResults() {
        resultsStack.clear()
    }

    func getCurrentResults() -> [ImageDataModelProtocolWrapper]? {
        resultsStack.getLast()?.values
    }

    func popResults() -> [ImageDataModelProtocolWrapper]? {
        return resultsStack.popResults()?.values
    }

    func popToTop() -> [ImageDataModelProtocolWrapper]? {
        return resultsStack.popToTop()?.values
    }

    var penultimateTitle: String {
        return resultsStack.getPenultimate()?.title ?? ""
    }

    var title: String {
        return resultsStack.getLast()?.title ?? ""
    }

    var tagsArray: [String] {
        var tagsSet = Set<String>()

        if let imageModels = getCurrentResults() {
            for imageModel in imageModels {
                tagsSet.formUnion(imageModel.imageModel.tags)
            }
        }

        return [String](tagsSet).sorted {$0 < $1}
    }
}

extension DataSource: HTTPURLResponseNot200 {
    // handle non-200 response codes -- in case there's more info available
    // returns true if it "consumes" the case
    internal func responseHandler(urlResponse: HTTPURLResponse,
                                  data: Data?,
                                  completion: @escaping (DataResult) -> Void) -> Bool {
        if [401, 403].contains(urlResponse.statusCode), let data = data {
            let result: Result<MessageModel, ReferenceError> = data.decodeData()

            if case .success(let messageModel) = result {
                //print("403 error: \(messageModel.message)")
                var message = messageModel.message
                if urlResponse.statusCode == 403 {
                    message = "API Key might be incorrect.  Go to Settings to check it."
                }
                completion(.failure(.apiNotHappy(message: message)))
                return true
            }
        }

        return false
    }
}
