//
//  UserDefaultsManager.swift
//  GIPHYTags
//
//  Created by David S Reich on 9/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

//UserDefaults plus ...

class UserDefaultsManager {

    private static let InitialTagsKey = "initialtags"
    private static let MaxNumberOfImagesKey = "maxnumberofImages"
    private static let MaxNumberOfLevelsKey = "maxnumberofLevels"
    private static let GIPHYApiKeyKey = "GIPHYApiKey"

    private static let defaultInitialTags = "weather"  //plus delimited list i.e. "tag1+tag2+tag3"
    private static let defaultMaxNumberOfImages = 25
    private static let defaultMaxNumberOfLevels = 5

    private static let appDefaults = UserDefaults.standard

    private static let defaultGIPHYApiKey = ""

    private class var GIPHYApiKey: String {
        get {
            return appDefaults.string(forKey: GIPHYApiKeyKey) ?? defaultGIPHYApiKey
        }
        set(newApiKey) {
            appDefaults.set(newApiKey, forKey: GIPHYApiKeyKey)
        }
    }

    class func getInitialTags(defaults: UserDefaults = UserDefaultsManager.appDefaults) -> String {
        guard let tags = defaults.string(forKey: InitialTagsKey) else {
            return defaultInitialTags
        }
        return tags.isEmpty ? defaultInitialTags : tags
    }

    private class func setInitialTags(initialTags: String?, defaults: UserDefaults = UserDefaultsManager.appDefaults) {
        defaults.set(initialTags, forKey: InitialTagsKey)
    }

    private class func getMaxNumberOfImages(defaults: UserDefaults = UserDefaultsManager.appDefaults) -> Int {
        let number = defaults.integer(forKey: MaxNumberOfImagesKey)
        return number <= 0 ? defaultMaxNumberOfImages : number
    }

    private class func setMaxNumberOfImages(maxNumber: Int, defaults: UserDefaults = UserDefaultsManager.appDefaults) {
        defaults.set(maxNumber, forKey: MaxNumberOfImagesKey)
    }

    private class func getMaxNumberOfLevels(defaults: UserDefaults = UserDefaultsManager.appDefaults) -> Int {
        let number = defaults.integer(forKey: MaxNumberOfLevelsKey)
        return number <= 0 ? defaultMaxNumberOfLevels : number
    }

    private class func setMaxNumberOfLevels(maxNumber: Int, defaults: UserDefaults = UserDefaultsManager.appDefaults) {
        defaults.set(maxNumber, forKey: MaxNumberOfLevelsKey)
    }

    class func getUserSettings() -> UserSettings {
        return UserSettings(initialTags: UserDefaultsManager.getInitialTags(),
                            giphyAPIKey: UserDefaultsManager.GIPHYApiKey,
                            maxNumberOfImages: UserDefaultsManager.getMaxNumberOfImages(),
                            maxNumberOfLevels: UserDefaultsManager.getMaxNumberOfLevels())
    }

    class func saveUserSettings(userSettings: UserSettings) {
        UserDefaultsManager.setInitialTags(initialTags: userSettings.initialTags)
        UserDefaultsManager.GIPHYApiKey = userSettings.giphyAPIKey
        UserDefaultsManager.setMaxNumberOfImages(maxNumber: userSettings.maxNumberOfImages)
        UserDefaultsManager.setMaxNumberOfLevels(maxNumber: userSettings.maxNumberOfLevels)
    }

    class func hasAPIKey() -> Bool {
        return !UserDefaultsManager.GIPHYApiKey.isEmpty
    }
}
