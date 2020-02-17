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
    var images: [ImageDataModelProtocolWrapper] { get }
}

class ImageDataSource {
    internal var images: [ImageDataModelProtocolWrapper]

    internal lazy var tagsArray: [String] = {
        var tagsSet = Set<String>()

        for imageModel in images {
            tagsSet.formUnion(imageModel.imageModel.tags)
        }

        return [String](tagsSet).sorted {$0 < $1}
    }()

    init(with images: [ImageDataModelProtocolWrapper]) {
        self.images = images
    }

    private func clearImages() {
        images.removeAll()
    }
}

extension ImageDataSource: ImageDataSourceProtocol {
    func clear() {
        clearImages()
    }
}
