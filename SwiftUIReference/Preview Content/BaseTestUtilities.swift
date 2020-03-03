//
//  BaseTestUtilities.swift
//  SwiftUIReferenceTests
//
//  Created by David S Reich on 4/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import UIKit

// moved this out of unit tests so it could be used for previews!!!

class BaseTestUtilities {

    static let numberOfImagesInGiphyModel = 3
    static let tagsString = "abc-efg-hij"
    static let imagePath = "https://media1.giphy.com/media/YnH5fDZPcNJfi/200w.gif"
    static let largeImagePath = "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.gif"
    static let width = CGFloat(282)
    static let height = CGFloat(402)
    static let widthString = "282"
    static let heightString = "402"
    static let largeWidth = CGFloat(280)
    static let largeHeight = CGFloat(400)
    static let largeWidthString = "280"
    static let largeHeightString = "400"

    static private let basicImageJSONString =
    #"""
        {
            "frames": "60",
            "hash": "627ff8a082be87d1e8ce2a9f7a0ffbdb",
            "height": "400",
            "mp4": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.mp4",
            "mp4_size": "226554",
            "size": "88540",
            "url": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.gif",
            "webp": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.webp",
            "webp_size": "92686",
            "width": "280"
        }
    """#

    static private let basicImageJSONString2 =
    #"""
        {
            "frames": "60",
            "hash": "627ff8a082be87d1e8ce2a9f7a0ffbdb",
            "height": "402",
            "mp4": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.mp4",
            "mp4_size": "226554",
            "size": "88540",
            "url": "https://media1.giphy.com/media/YnH5fDZPcNJfi/200w.gif",
            "webp": "https://media1.giphy.com/media/YnH5fDZPcNJfi/giphy.webp",
            "webp_size": "92686",
            "width": "282"
        }
    """#

    static private let metaModelString =
    """
        {
            "status": 200,
            "msg": "OK"
        }
    """

    static private let messageModelString =
    """
        {
            "message": "Invalid authentication credentials"
        }
    """

    static private func imagesModelString() -> String {
        return """
            {
                "original": \(basicImageJSONString),
                "fixed_width": \(basicImageJSONString2)
            }
        """
    }

    static private func imageDataModelString() -> String {
        return """
            {
                "title": "This is the title",
                "slug": "abc-efg-hij-klm",
                "images": \(imagesModelString())
            }
        """
    }

    static private func giphyModelString() -> String {
        return """
            {
                "meta" : {
                  "status" : 200,
                  "msg" : "OK"
                },
                "data":
                    [{
                        "title": "This is the title1",
                        "slug": "abc-efg-hij-klm",
                        "images": \(imagesModelString())
                    },
                    {
                        "title": "This is the title2",
                        "slug": "abc-efg-hij-klm",
                        "images": \(imagesModelString())
                    },
                    {
                        "title": "This is the title3",
                        "slug": "abc-efg-hij-klm",
                        "images": \(imagesModelString())
                    }]
            }
        """
    }

    class func getBasicImageData() -> Data {
        return Data(basicImageJSONString.utf8)
    }

    class func getMetaModelData() -> Data {
        return Data(metaModelString.utf8)
    }

    class func getMessageModelData() -> Data {
        return Data(messageModelString.utf8)
    }

    class func getImagesModelData() -> Data {
        return Data(imagesModelString().utf8)
    }

    class func getImageDataModelData() -> Data {
        return Data(imageDataModelString().utf8)
    }

    class func getGiphyModelData() -> Data {
        return Data(giphyModelString().utf8)
    }

    class func getImageModel() -> ImageDataModel? {
        let jsonData = BaseTestUtilities.getImageDataModelData()
        let result: Result<ImageDataModel, ReferenceError> = jsonData.decodeData()
        // if decode fails it will be caught in another test.

        if case .success(let imageDataModel) = result {
            return imageDataModel
        }

        return nil
    }
}
