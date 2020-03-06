//
//  LoadableImageView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 10/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Combine
import SwiftUI

struct LoadableImageView: View {

    let imageUrlString: String

    @ObservedObject var imageLoader: ImageLoader
    @State var image = UIImage()

    init(withURL url: String) {
        self.imageUrlString = url
        self.imageLoader = ImageLoader(urlString: url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }.onReceive(imageLoader.imagePublisher) { image in
            self.image = image
        }
    }
}

struct LoadableImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadableImageView(withURL: "https://media0.giphy.com/media/10N782ExqDjCLK/giphy.gif")
    }
}
