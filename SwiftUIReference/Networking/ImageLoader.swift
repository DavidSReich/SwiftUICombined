//
//  ImageLoader.swift
//  SwiftUIReference
//
//  Created by David S Reich on 12/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Combine
import UIKit

class ImageLoader: ObservableObject {
    var imagePublisher = PassthroughSubject<UIImage, Never>()
    private static let imageCache = NSCache<NSString, UIImage>()

    var image = UIImage() {
        didSet {
            imagePublisher.send(image)
        }
     }

    private var downloadTask: URLSessionDataTask?

    init(urlString: String) {

        //if we already are downloading a file stop it - we won't need that one.
        if downloadTask != nil {
            downloadTask?.cancel()
            downloadTask = nil
        }

        if let image = ImageLoader.imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = image
            }

            return
        }

        downloadTask = URLSession.urlSessionDataTask(urlString: urlString, mimeType: "image/gif") { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.handleData(data: data, urlString: urlString)
            case .failure(let referenceError):
                // fail silently
                print("Cannot get image data from: \(String(describing: referenceError.errorDescription))")
                // referenceError
            }
        }
    }

    private func handleData(data: Data, urlString: String) {
        guard let image = UIImage(data: data) else {
            print("Can't make UIImage from data!!!")
            return
        }

        DispatchQueue.main.async {
            // print("new image: \(urlString)")
            ImageLoader.imageCache.setObject(image, forKey: urlString as NSString)
            self.image = image
        }
    }
}
