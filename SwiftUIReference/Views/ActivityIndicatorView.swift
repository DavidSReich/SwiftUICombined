//
//  ActivityIndicatorView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 9/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView

    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIViewType {
        UIViewType(style: style)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.startAnimating()
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView(style: .large)
    }
}
