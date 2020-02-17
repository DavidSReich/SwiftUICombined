//
//  SceneDelegate.swift
//  SwiftUIReference
//
//  Created by David S Reich on 8/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the SwiftUI view that provides the window contents.

        // get defaults
//        let userSettings = UserDefaultsManager.getUserSettings()
//        let contentView = PlainMainView(userSettings: userSettings,
//                                        mainViewLevel: 0,
//                                        imageTags: userSettings.initialTags)
//        let contentView = SolitaryMainView(userSettings: userSettings, mainViewLevel: 0, imageTags: userSettings.initialTags)
        let contentView = StarterView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
