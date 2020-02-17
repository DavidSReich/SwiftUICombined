//
//  GiphyImageView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 11/12/19.
//  Copyright © 2019 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftGifOrigin
import SwiftUI

struct GiphyImageView: View {
    let width: CGFloat
    let height: CGFloat

    @ObservedObject var dataLoader: DataLoader
    @State var image = UIImage()

    init(withURL url: String, width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        self.dataLoader = DataLoader(urlString: url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: self.width, height: self.height)
        }.onReceive(dataLoader.dataPublisher) { data in
            self.image = UIImage.gif(data: data) ?? UIImage()
        }
    }
}

struct GiphyImageView_Previews: PreviewProvider {
    static var previews: some View {
        GiphyImageView(withURL: "", width: 100, height: 100)
    }
}
