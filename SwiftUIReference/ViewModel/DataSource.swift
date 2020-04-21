//
//  DataSource.swift
//  SwiftUIReference
//
//  Created by David S Reich on 7/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import Combine

class DataSource {
    private let networkService: NetworkService

    private var resultsStack = ResultsStack<ImageDataModelProtocolWrapper>()
    private var disposables = Set<AnyCancellable>()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getData(tagString: String,
                 urlString: String,
                 mimeType: String,
                 completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        guard let dataPublisher = networkService.getDataPublisher(urlString: urlString, mimeType: mimeType, not200Handler: self) else {
            completion(.badURL)
            return
        }

        dataPublisher
            .flatMap(maxPublishers: .max(1)) { data -> AnyPublisher<GiphyModel, ReferenceError> in
                let ssws: AnyPublisher<GiphyModel, ReferenceError> = data.decodeData()
                return ssws
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { value in
            switch value {
            case .failure(let error):
                completion(error)
            case .finished:
                completion(nil)
            }
        }, receiveValue: { [weak self] giphyModel in
            guard let self = self else { return }
            self.resultsStack.pushResults(title: tagString, values: ImageDataModel.getWrappedImageModels(from: giphyModel))
        })
            .store(in: &disposables)
    }

    var resultsDepth: Int {
        resultsStack.resultsCount
    }

    func clearAllResults() {
        resultsStack.clear()
    }

    func popResults() -> [ImageDataModelProtocolWrapper]? {
        return resultsStack.popResults()?.values
    }

    func popToTop() -> [ImageDataModelProtocolWrapper]? {
        return resultsStack.popToTop()?.values
    }

    var currentResults: [ImageDataModelProtocolWrapper]? {
        resultsStack.getLast()?.values
    }

    var penultimateTitle: String {
        return resultsStack.getPenultimate()?.title ?? ""
    }

    var title: String {
        return resultsStack.getLast()?.title ?? ""
    }

    var tagsArray: [String] {
        var tagsSet = Set<String>()

        if let imageModels = currentResults {
            for imageModel in imageModels {
                tagsSet.formUnion(imageModel.imageModel.tags)
            }
        }

        return [String](tagsSet).sorted {$0 < $1}
    }
}

extension DataSource: HTTPURLResponseNot200 {
    // handle non-200 response codes -- in case there's more info available
    // returns nil if no error mapping was performed
    internal func mapError(urlResponse: HTTPURLResponse, data: Data?) -> ReferenceError? {
        if [401, 403].contains(urlResponse.statusCode), let data = data {
            let result: Result<MessageModel, ReferenceError> = data.decodeData()

            if case .success(let messageModel) = result {
                //print("403 error: \(messageModel.message)")
                var message = messageModel.message
                if urlResponse.statusCode == 403 {
                    message = "API Key might be incorrect.  Go to Settings to check it."
                }

                return .apiNotHappy(message: message)
            }
        }

        return nil
    }
}
