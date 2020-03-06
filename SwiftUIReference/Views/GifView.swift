//
//  GifView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 19/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI
import UIKit
import SwiftGifOrigin

struct GifView: UIViewRepresentable {
    private static let imageCache = NSCache<NSString, UIImage>()

    var imageUrlString: String

    func makeUIView(context: Context) -> UIImageView {
        UIImageView()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if let cachedImage = GifView.imageCache.object(forKey: imageUrlString as NSString) {
            uiView.image = cachedImage
        } else if let image = UIImage.gif(url: imageUrlString) {
            GifView.imageCache.setObject(image, forKey: imageUrlString as NSString)
            //print(">>> cached: \(imageUrlString)")
            uiView.image = image
        }
    }
}

struct GifView_Previews: PreviewProvider {
    static var previews: some View {
        GifView(imageUrlString: Bundle.main.url(forResource: "fish", withExtension: "gif")!.absoluteString)
    }
}
