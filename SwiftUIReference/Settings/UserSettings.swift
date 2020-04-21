//
//  UserSettings.swift
//  SwiftUIReference
//
//  Created by David S Reich on 8/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

struct UserSettings: Equatable {
    var initialTags: String
    var giphyAPIKey: String
    var maxNumberOfImages: Int
    var maxNumberOfLevels: Int
}

extension UserSettings {

    private static let urlTemplate = "https://api.giphy.com/v1/gifs/search?api_key={API_KEY}&limit={MAX_IMAGES}&q={TAGS}"

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
                            maxNumberOfLevels: 5)
    }
}
