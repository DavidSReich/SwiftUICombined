//
//  ImageDataSourceTests.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 28/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import XCTest

class ImageDataSourceTests: XCTestCase {
//    private var imageDataSource: ImageDataSourceProtocol = ImageDataSource(with: [])
//
//    override func setUp() {
//        let jsonData = BaseTestUtilities.getGiphyModelData()
//
//        let result: Result<GiphyModel, ReferenceError> = jsonData.decodeData()
//        // this was more thoroughly tested elsewhere
//
//        if case .success(let giphyModel) = result {
//            let imageDataModels = ImageDataModel.getWrappedImageModels(from: giphyModel)
//            self.imageDataSource = ImageDataSource(with: imageDataModels)
//        }
//    }
//
//    func testImageDataSource() {
//        let images = imageDataSource.images
//        XCTAssertEqual(BaseTestUtilities.numberOfImagesInGiphyModel, images.count)
//
//        let tagsStringSorted = BaseTestUtilities.tagsString.components(separatedBy: "-").sorted {$0 < $1}.joined(separator: "-")
//        XCTAssertEqual(tagsStringSorted, imageDataSource.tagsArray.joined(separator: "-"))
//
//        let imageModel = images[1]
//
//        XCTAssertEqual(BaseTestUtilities.imagePath, imageModel.imageModel.imagePath)
//        XCTAssertEqual(BaseTestUtilities.largeImagePath, imageModel.imageModel.largeImagePath)
//        XCTAssertEqual(BaseTestUtilities.tagsString, imageModel.imageModel.tags.joined(separator: "-"))
//        let (imageHeight, imageWidth) = (imageModel.imageModel.imageSize.height, imageModel.imageModel.imageSize.width)
//        XCTAssertEqual(BaseTestUtilities.height, imageHeight)
//        XCTAssertEqual(BaseTestUtilities.width, imageWidth)
//        let (largeImageHeight, largeImageWidth) =
//            (imageModel.imageModel.largeImageSize.height, imageModel.imageModel.largeImageSize.width)
//        XCTAssertEqual(BaseTestUtilities.largeHeight, largeImageHeight)
//        XCTAssertEqual(BaseTestUtilities.largeWidth, largeImageWidth)
//    }

}
