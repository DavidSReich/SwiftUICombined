//
//  DataManager.swift
//  SwiftUIReference
//
//  Created by David S Reich on 9/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import RxSwift

protocol HandleReferenceErrorProtocol {
    func handleReferenceError(referenceError: ReferenceError)
}

protocol DataManagerProtocol: ResultDictProtocol {
    var imageModels: [ImageDataModelProtocolWrapper] { get }
    var tagsArray: [String] { get }
    func clearDataSource()
    func populateDataSource(urlString: String,
                            useRxSwift: Bool,
                            networkingType: UserSettings.NetworkingType,
                            completion: @escaping (_ referenceError: ReferenceError?) -> Void)
}

protocol ResultDictProtocol {
    func saveResults(index: Int, tagsString: String)
    func getResults(index: Int)
    func getLastTagsString(index: Int) -> String
    var tagString: String { get }
}

class DataManager {

    private var resultsStack = ResultsStack()
    private let disposeBag = DisposeBag()
    private var imageDataSource: ImageDataSourceProtocol = ImageDataSource(with: [])
    private var currentTagString = ""

    private func fillDataSource(urlString: String,
                                useRxSwift: Bool,
                                networkingType: UserSettings.NetworkingType,
                                completion: @escaping (_ referenceError: ReferenceError?) -> Void) {

        clearDataSource()

        if useRxSwift {
            getJSONWithRxSwift(urlString: urlString, networkingType: networkingType, completion: completion)
        } else {
            getJSONWithoutRxSwift(urlString: urlString, networkingType: networkingType, completion: completion)
        }
    }

    private func getJSONWithoutRxSwift(urlString: String,
                                       networkingType: UserSettings.NetworkingType,
                                       completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        let referenceError = JSONNetworkService.getJSON(urlString: urlString, networkingType: networkingType) { result in
            switch result {
            case .success(let data):
                self.handleData(data: data, completion: completion)
            case .failure(let referenceError):
                completion(referenceError)
            }
        }

        if let referenceError = referenceError {
            completion(ReferenceError.noFetchJSON(referenceError: referenceError))
        }
    }

    private func getJSONWithRxSwift(urlString: String,
                                    networkingType: UserSettings.NetworkingType,
                                    completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        guard let jsonObservable = JSONNetworkService.getJSONObservable(urlString: urlString, networkingType: networkingType) else {
            completion(.badURL)
            return
        }

        jsonObservable.subscribe(onNext: { result in
            switch result {
            case .success(let data):
                self.handleData(data: data, completion: completion)
            case .failure(let referenceError):
                completion(referenceError)
            }
        },
        onError: { error in
            print("error: \(error)")
            completion(error as? ReferenceError ?? .dataTask(error: error))
        }).disposed(by: disposeBag)
    }

    private func handleData(data: Data, completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        self.prettyPrintData(data: data)

        let result: Result<GiphyModel, ReferenceError> = data.decodeData()
        switch result {
        case .success(let giphyModel):
            let imageDataModels = ImageDataModel.getWrappedImageModels(from: giphyModel)
            //print("imagemodels: \(imageDataModels)")
            //print("imagemodels.count: \(imageDataModels.count)")

            self.imageDataSource = ImageDataSource(with: imageDataModels)
            completion(nil)
        case .failure(let referenceError):
            self.imageDataSource = ImageDataSource(with: [ImageDataModelProtocolWrapper]())
            completion(referenceError)
        }
    }

    // handy for debugging
    private func prettyPrintData(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                if let detailString = String(data: prettyPrintedData, encoding: .utf8) {
                    print("json:\n\(detailString)")
                }
            }
        }
    }
}

//this mainly just hides the imageDataSource
extension DataManager: DataManagerProtocol {
    internal var imageModels: [ImageDataModelProtocolWrapper] {
        return imageDataSource.images
    }

    internal var tagsArray: [String] {
        return imageDataSource.tagsArray
    }

    func clearDataSource() {
        imageDataSource.clear()
    }

    func populateDataSource(urlString: String,
                            useRxSwift: Bool,
                            networkingType: UserSettings.NetworkingType,
                            completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        fillDataSource(urlString: urlString, useRxSwift: useRxSwift, networkingType: networkingType, completion: completion)
    }
}

extension DataManager: ResultDictProtocol {
    func saveResults(index: Int, tagsString: String) {
        resultsStack.saveResults(index: index, tagsString: tagsString, images: imageDataSource.images)
    }

    func getResults(index: Int) {
        if let results = resultsStack.getResults(index: index) {
            currentTagString = results.tagsString
            imageDataSource = ImageDataSource(with: results.images)
        }
    }

    func getLastTagsString(index: Int) -> String {
        return resultsStack.getResults(index: index)?.tagsString ?? ""
    }

    var tagString: String {
        return currentTagString
    }
}
