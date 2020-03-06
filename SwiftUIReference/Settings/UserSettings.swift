//
//  UserSettings.swift
//  SwiftUIReference
//
//  Created by David S Reich on 8/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

class UserSettings: ObservableObject {
    var initialTags: String
    var giphyAPIKey: String
    var maxNumberOfImages: Int
    var maxNumberOfLevels: Int
    var useRxSwift: Bool
    var networkingType: NetworkingType

    init(initialTags: String,
         giphyAPIKey: String,
         maxNumberOfImages: Int,
         maxNumberOfLevels: Int,
         useRxSwift: Bool,
         networkingType: NetworkingType) {
        self.initialTags = initialTags
        self.giphyAPIKey = giphyAPIKey
        self.maxNumberOfImages = maxNumberOfImages
        self.maxNumberOfLevels = maxNumberOfLevels
        self.useRxSwift = useRxSwift
        self.networkingType = networkingType
    }
}

extension UserSettings: Equatable {
    static func == (lhs: UserSettings, rhs: UserSettings) -> Bool {
        if lhs.initialTags != rhs.initialTags ||
            lhs.giphyAPIKey != rhs.giphyAPIKey ||
            lhs.maxNumberOfImages != rhs.maxNumberOfImages ||
            lhs.maxNumberOfLevels != rhs.maxNumberOfLevels ||
            lhs.useRxSwift != rhs.useRxSwift ||
            lhs.networkingType != rhs.networkingType {
            return false
        }

        return true
    }
}

extension UserSettings {

    private static let urlTemplate = "https://api.giphy.com/v1/gifs/search?api_key={API_KEY}&limit={MAX_IMAGES}&q={TAGS}"

    enum NetworkingType: Int {
        case alamoFire
        case urlSession
    }

    func getFullUrlString(tags: String) -> String {

        return UserSettings.urlTemplate
            .replacingOccurrences(of: "{API_KEY}", with: giphyAPIKey)
            .replacingOccurrences(of: "{MAX_IMAGES}", with: "\(maxNumberOfImages)")
            .replacingOccurrences(of: "{TAGS}", with: tags)
    }

    static func getDefaultUserSettings() -> UserSettings {
        //there's no default API key
        return UserSettings(initialTags: "weather",
                            giphyAPIKey: "",
                            maxNumberOfImages: 7,
                            maxNumberOfLevels: 5,
                            useRxSwift: false,
                            networkingType: .urlSession)
    }
}
