//
//  StarterView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 5/2/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

struct StarterView: View {
    @State private var showLaunchScreen = true

    // get defaults
    let userSettings = UserDefaultsManager.getUserSettings()
    let solitaryViewModel = SolitaryViewModel(dataManager: DataManager(),
                                                             userSettings: UserDefaultsManager.getUserSettings())

    var body: some View {
        Group {
            if showLaunchScreen {
                LaunchScreenView(isPresented: $showLaunchScreen)
            } else {
//                PlainMainView(userSettings: userSettings, mainViewLevel: 0, imageTags: userSettings.initialTags)
//                SolitaryMainView(userSettings: userSettings, mainViewLevel: 0, imageTags: userSettings.initialTags)
                SolitaryMainView(solitaryViewModel: solitaryViewModel)
            }
        }
    }
}

struct StarterView_Previews: PreviewProvider {
    static var previews: some View {
        StarterView()
    }
}
