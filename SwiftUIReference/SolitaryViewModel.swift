//
//  SolitaryViewModel.swift
//  SwiftUIReference
//
//  Created by David S Reich on 4/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import SwiftUI

class SolitaryViewModel {

    private let settingsButtonText = "Settings"
    private let pickTagsButtonText = "Pick Tags"
    private let startButtonText = "Start"

    private var dataManager: DataManagerProtocol
//    var dataManager: DataManagerProtocol
//    private var userSettings: UserSettings
//    @ObservedObject var userSettings: UserSettings
    var userSettings: UserSettings

    private var viewLevel: Int = 0
    private var imageTags: String

    init(dataManager: DataManagerProtocol, userSettings: UserSettings) {
        self.dataManager = dataManager
        self.userSettings = userSettings
        imageTags = userSettings.initialTags
    }

    var mainViewLevel: Int {
        get {
            viewLevel
        }

        set {
            viewLevel = newValue
        }
    }

    var tagString: String {
        get {
            imageTags
        }

        set {
            imageTags = newValue
        }
    }

    var title: String {
        isTopMainLevel ? "Starting Images" : imageTags
    }

    var isTopMainLevel: Bool {
        mainViewLevel == 0
    }

    var isBackButtonSettings: Bool {
        isTopMainLevel
    }

    var isRightButtonPickTags: Bool {
        mainViewLevel < userSettings.maxNumberOfLevels
    }

    var backButtonText: String {
        isBackButtonSettings ? settingsButtonText : dataManager.getLastTagsString(index: mainViewLevel - 1)
    }

    var rightButtonText: String {
        isRightButtonPickTags ? pickTagsButtonText : startButtonText
    }

    // dataManager
    // dataManager
    // dataManager
    // dataManager

    var tagsArray: [String] {
        dataManager.tagsArray
    }

    func saveResults(index: Int) {
        dataManager.saveResults(index: index, tagsString: imageTags)
    }

    func getResults(index: Int) {
        dataManager.getResults(index: index)
        imageTags = dataManager.tagString
    }

//    func getLastTagsString(index: Int) -> String

//    var tagString: String {
//        dataManager.tagString
//    }

    func clearDataSource() {
        dataManager.clearDataSource()
    }

    var imageModels: [ImageDataModelProtocolWrapper] {
        dataManager.imageModels
    }

    func populateDataSource(imageTags: String, completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        self.imageTags = imageTags
        let urlString = userSettings.getFullUrlString(tags: imageTags)
        dataManager.populateDataSource(urlString: urlString,
                                            useRxSwift: userSettings.useRxSwift,
                                            networkingType: userSettings.networkingType,
                                            completion: completion)
    }
}
