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
    private static let UseRxSwiftKey = "UseRxSwift"
    private static let NetworkingTypeKey = "NetworkingType"

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

    private class func getNetworkingType(defaults: UserDefaults = UserDefaultsManager.appDefaults) -> UserSettings.NetworkingType {
        let typeIndex = defaults.integer(forKey: NetworkingTypeKey)
        return UserSettings.NetworkingType(rawValue: typeIndex) ?? .urlSession
    }

    private class func setNetworkingType(networkingType: UserSettings.NetworkingType,
                                         defaults: UserDefaults = UserDefaultsManager.appDefaults) {
        defaults.set(networkingType.rawValue, forKey: NetworkingTypeKey)
    }

    private class func getUseRxSwift(defaults: UserDefaults = UserDefaultsManager.appDefaults) -> Bool {
        return defaults.bool(forKey: UseRxSwiftKey)
    }

    private class func setUseRxSwift(useRxSwift: Bool, defaults: UserDefaults = UserDefaultsManager.appDefaults) {
        defaults.set(useRxSwift, forKey: UseRxSwiftKey)
    }

    class func getUserSettings() -> UserSettings {
        return UserSettings(initialTags: UserDefaultsManager.getInitialTags(),
                            giphyAPIKey: UserDefaultsManager.GIPHYApiKey,
                            maxNumberOfImages: UserDefaultsManager.getMaxNumberOfImages(),
                            maxNumberOfLevels: UserDefaultsManager.getMaxNumberOfLevels(),
                            useRxSwift: UserDefaultsManager.getUseRxSwift(),
                            networkingType: UserDefaultsManager.getNetworkingType())
    }

    class func saveUserSettings(userSettings: UserSettings) {
        UserDefaultsManager.setInitialTags(initialTags: userSettings.initialTags)
        UserDefaultsManager.GIPHYApiKey = userSettings.giphyAPIKey
        UserDefaultsManager.setMaxNumberOfImages(maxNumber: userSettings.maxNumberOfImages)
        UserDefaultsManager.setMaxNumberOfLevels(maxNumber: userSettings.maxNumberOfLevels)
        UserDefaultsManager.setUseRxSwift(useRxSwift: userSettings.useRxSwift)
        UserDefaultsManager.setNetworkingType(networkingType: userSettings.networkingType)
    }

    class func hasAPIKey() -> Bool {
        return !UserDefaultsManager.GIPHYApiKey.isEmpty
    }
}
