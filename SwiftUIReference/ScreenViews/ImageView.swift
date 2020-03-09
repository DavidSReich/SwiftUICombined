//
//  ImageView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 11/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct ImageView: View {
    var imageModel: ImageDataModelProtocol

    var body: some View {
        ZStack {
            Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))

            GeometryReader { geometry in
                GifView(imageUrlString: self.imageModel.largeImagePath)
                    .frame(width: self.imageModel.largeImageSize.width, height: self.imageModel.largeImageSize.height)
                    .border(Color.orange, width: 5)
                    .shadow(color: .orange, radius: 15)
                    .scaleEffect(self.fitImageInScreen(size: geometry.size))
            }

        }.navigationBarTitle(Text(imageModel.imageTitle), displayMode: .inline)
    }

    private func fitImageInScreen(size: CGSize) -> CGFloat {
        let screenHeight = size.height
        let screenWidth = size.width

        guard screenHeight != 0,
            screenWidth != 0 else {
                return 1
        }

        let imageHeight = imageModel.largeImageSize.height
        let imageWidth = imageModel.largeImageSize.width

        let image2ScreenHeightRatio = imageHeight / screenHeight
        let image2ScreenWidthRatio = imageWidth / screenWidth

        let maxImage2ScreenRatio = max(image2ScreenWidthRatio, image2ScreenHeightRatio)

        let scaleAmount = 0.9 / maxImage2ScreenRatio

        return scaleAmount
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageModel: BaseTestUtilities.getFishImageModel()!)
    }
}
