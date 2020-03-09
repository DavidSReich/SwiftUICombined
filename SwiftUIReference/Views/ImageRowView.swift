//
//  ImageRowView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 11/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct ImageRowView: View {
    var imageModel: ImageDataModelProtocol
    var showOnLeft: Bool

    var body: some View {
        HStack {
            if showOnLeft {
                Spacer()
            }

//            LoadableImageView(withURL: imageModel.getImagePath())
//                .frame(width: self.imageModel.getImageSize().width, height: imageModel.getImageSize().height)
//                .padding(5)
//                .border(Color.blue, width: 5)
//                .shadow(color: .blue, radius: 10)
//                .padding()

            GifView(imageUrlString: imageModel.imagePath)
                .frame(width: imageModel.imageSize.width, height: imageModel.imageSize.height)
                .border(Color.blue, width: 5)
                .shadow(color: .blue, radius: 10)
                .padding()

            if !showOnLeft {
                Spacer()
            }
        }
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageRowView(imageModel: BaseTestUtilities.getFishImageModel()!, showOnLeft: true)
            ImageRowView(imageModel: BaseTestUtilities.getFishImageModel()!, showOnLeft: false)
        }
    }
}
