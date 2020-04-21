//
//  SolitaryViewModel.swift
//  SwiftUIReference
//
//  Created by David S Reich on 4/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

class SolitaryViewModel: ObservableObject {

    @Published var imageModels: [ImageDataModelProtocolWrapper] = []

    private let settingsButtonText = "Settings"
    private let pickTagsButtonText = "Pick Tags"
    private let startButtonText = "Start"

    private var dataSource: DataSource
    var userSettings: UserSettings

    private var imageTags: String

    init(dataSource: DataSource, userSettings: UserSettings) {
        self.dataSource = dataSource
        self.userSettings = userSettings
        imageTags = userSettings.initialTags
    }

    var mainViewLevel: Int {
        let level = dataSource.resultsDepth - 1
        return level > 0 ? level : 0
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
        isTopMainLevel ? "Starting Images" : dataSource.title
    }

    var isTopMainLevel: Bool {
        mainViewLevel == 0
    }

    var isBackButtonSettings: Bool {
        isTopMainLevel
    }

    var isRightButtonPickTags: Bool {
        mainViewLevel <= userSettings.maxNumberOfLevels
    }

    var backButtonText: String {
        isBackButtonSettings ? settingsButtonText : dataSource.penultimateTitle
    }

    var rightButtonText: String {
        isRightButtonPickTags ? pickTagsButtonText : startButtonText
    }

    // DataSource:

    func goBackOneLevel() {
        imageModels = dataSource.popResults() ?? []
    }

    func goBackToTop() {
        imageModels = dataSource.popToTop() ?? []
    }

    func clearDataSource() {
        dataSource.clearAllResults()
        imageModels = dataSource.currentResults ?? []
    }

    var tagsArray: [String] {
        dataSource.tagsArray
    }

    func populateDataSource(imageTags: String, completion: @escaping (_ referenceError: ReferenceError?) -> Void) {
        self.imageTags = imageTags
        let urlString = userSettings.getFullUrlString(tags: imageTags)

        dataSource.getData(tagString: imageTags,
                           urlString: urlString,
                           mimeType: "application/json") { refError in
                            self.imageModels = self.dataSource.currentResults ?? []
                            completion(refError)
        }
    }
}
