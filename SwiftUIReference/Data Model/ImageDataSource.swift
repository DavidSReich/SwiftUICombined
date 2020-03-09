//
//  ImageDataSource.swift
//  SwiftUIReference
//
//  Created by David S Reich on 9/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

protocol ImageDataSourceProtocol {
    func clear()
    var tagsArray: [String] { get }
    var imageModels: [ImageDataModelProtocolWrapper] { get set }
}

class ImageDataSource: ImageDataSourceProtocol {
    private var images = [ImageDataModelProtocolWrapper]()

    internal var tagsArray = [String]()

    private func clearImages() {
        images.removeAll()
    }

    internal var imageModels: [ImageDataModelProtocolWrapper] {
        get {
            images
        }

        set {
            images = newValue
            tagsArray = ImageDataSource.makeTagsArray(images: images)
        }
    }

    static func makeTagsArray(images: [ImageDataModelProtocolWrapper]) -> [String] {
        var tagsSet = Set<String>()

        for imageModel in images {
            tagsSet.formUnion(imageModel.imageModel.tags)
        }

        return [String](tagsSet).sorted {$0 < $1}
    }

    internal func clear() {
        images.removeAll()
        tagsArray.removeAll()
    }
}
