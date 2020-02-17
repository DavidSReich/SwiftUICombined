//
//  LaunchScreenView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 5/2/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct LaunchScreenView: View {
    @Binding var isPresented: Bool

    var body: some View {
        Group {
            GeometryReader { geometry in
                if self.isPortrait(size: geometry.size) {
                    VStack {
                        Spacer()
                        VStack {
                            Image("Giphy_Logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(0.8)
                            Text("Tags").font(.largeTitle).bold()
                                .scaleEffect(2.0)
                        }

                        Spacer()

                        VStack {
                            Text("Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.").font(.caption).bold()
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Image("PoweredBy_200px-White_HorizLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(0.7)
                                .padding(.bottom)
                        }
                    }
                } else {
                    VStack(alignment: .center, spacing: 20) {
                        Spacer()
                        Image("Giphy_Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(1.0)

                        HStack {
                            Spacer()
                            Text("Tags").font(.largeTitle).bold()
                            Spacer()
                        }.padding().padding()
                            .scaleEffect(2.0)
                            .padding()
                            .padding()

                        HStack {
                            Spacer()
                            Text("Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.").font(.headline)
                            Spacer()
                        }

                        HStack {
                            Image("PoweredBy_200px-White_HorizLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(0.5)
                        }
                    }
                }
            }
        }
        .onAppear(perform: self.goAway)
    }

    func goAway() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isPresented = false
        }
    }

    private func isPortrait(size: CGSize) -> Bool {
        return size.height > size.width
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    @State static var showLaunch = true
    static var previews: some View {
        Group {
            LaunchScreenView(isPresented: $showLaunch)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            LaunchScreenView(isPresented: $showLaunch)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max (13.4)")
            LaunchScreenView(isPresented: $showLaunch)
                .previewLayout(.fixed(width: 1136, height: 640))
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            LaunchScreenView(isPresented: $showLaunch)
                .previewLayout(.fixed(width: 2688, height: 1242))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max (13.4)")
        }
    }
}
