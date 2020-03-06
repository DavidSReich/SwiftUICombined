//
//  SolitaryMainView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 30/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

/*
 This is based on PlainMainView.
 SwiftUI currently has problems with navigation which break some of the features in PlainMainView.
 Avoid this problem altogether ...
 Stay in one View and stack up the searches.
 Pop them when the back button is pressed.
 */

struct SolitaryMainView: View {

    //inject this
    @State private var solitaryViewModel = SolitaryViewModel(dataManager: DataManager(),
                                                             userSettings: UserDefaultsManager.getUserSettings())

//    private let dataManager: DataManagerProtocol = DataManager()

    @State private var imageModels = [ImageDataModelProtocolWrapper]()
    @State private var nextImageTags = ""
    @State private var showingSelectorView = false
    @State private var showingSettingsView = false
    @State private var settingsChanged = true

    @State private var showingAlert = false

    // these cannot be private because the init() won't work
//    @State var userSettings: UserSettings
//    @State var mainViewLevel: Int
//    @State var imageTags: String

    @State private var alertMessageString: String?

//    let settingsButtonText = "Settings"
//    let pickTagsButtonText = "Pick Tags"
//    let startButtonText = "Start"

    // body used to be a lot more complicated, but still is helped by breaking it down into several funcs
    var body: some View {
        NavigationView {
            mainView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showingAlert) {
            if UserDefaultsManager.hasAPIKey() {
                return Alert(title: Text("Something went wrong!"),
                      message: Text( alertMessageString ?? "Unknown error!!??!!"),
                      dismissButton: .default(Text("Done")))
            } else {
                return Alert(title: Text("API Key is missing"),
                      message: Text("Go to Settings to enter an API Key"),
                      dismissButton: .default(Text("Done")))
            }
        }
    }

    private func mainView() -> some View {
        VStack {
            baseListWithNavBarView()
            .navigationBarTitle(Text(solitaryViewModel.title), displayMode: .inline)
            .onAppear(perform: loadEverything)
        }
    }

    private func baseListWithNavBarView() -> some View {
        basicImageList()
        .navigationBarItems(
            leading: leadingNavigationItem(),
            trailing: trailingNavigationItem()
        )
    }

    private func basicImageList() -> some View {
        List(imageModels.indices, id: \.self) { index in
            NavigationLink(destination: ImageView(imageModel: self.imageModels[index].imageModel)) {
                ImageRowView(imageModel: self.imageModels[index].imageModel, showOnLeft: index.isMultiple(of: 2))
            }
        }
    }

    private func leadingNavigationItem() -> some View {
        // swiftlint:disable multiple_closures_with_trailing_closure
        Button(solitaryViewModel.backButtonText) {
            if self.solitaryViewModel.isBackButtonSettings {
                self.settingsChanged = false
                self.showingSettingsView = true
            } else {
                //print(">>>>> mainViewLevel = \(self.mainViewLevel)")

                let nextMainViewLevel = self.solitaryViewModel.mainViewLevel > 1 ? self.solitaryViewModel.mainViewLevel - 1 : 0
                self.goBackToMainViewLevel(mainViewLevel: nextMainViewLevel)
            }
        }
        .sheet(isPresented: $showingSettingsView, onDismiss: {
            self.loadEverything()
        }) {
            SettingsView(isPresented: self.$showingSettingsView,
                         userSettings: self.$solitaryViewModel.userSettings,
                         tags: self.$solitaryViewModel.tagString,
                         settingsChanged: self.$settingsChanged)
        }
    }

    private func trailingNavigationItem() -> some View {
        Button(solitaryViewModel.rightButtonText) {
            if self.solitaryViewModel.isRightButtonPickTags {
                self.nextImageTags = ""
                self.showingSelectorView = true
            } else {
                self.goBackToMainViewLevel(mainViewLevel: 0)
            }
        }
        .sheet(isPresented: $showingSelectorView, onDismiss: {
            if !self.nextImageTags.isEmpty {
                self.solitaryViewModel.saveResults(index: self.solitaryViewModel.mainViewLevel)
                self.solitaryViewModel.tagString = self.nextImageTags
                self.solitaryViewModel.mainViewLevel += 1
                self.settingsChanged = true
                self.loadEverything()
            }
        }) {
            SelectorView(isPresented: self.$showingSelectorView,
                         selectedStrings: self.$nextImageTags,
                         allStrings: self.solitaryViewModel.tagsArray)
        }
    }

    private func loadEverything() {

        guard settingsChanged else {
            return
        }

        settingsChanged = false

        //clear and then reloadData with empty in case populateDataSource fails -
        //if it fails completely it won't call any of the completion callbacks.
//        solitaryViewModel.clearDataSource()
//        imageModels = solitaryViewModel.imageModels

        //need a delay so that screen can completely refresh after imageModels was reset
        //adjust the delay for best UX ... too short and the screen doesn't completely refresh
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.getImageModels()
//        }
//        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 0.5) {
            self.getImageModels()
//        }
    }

    private func goBackToMainViewLevel(mainViewLevel: Int) {
        self.solitaryViewModel.mainViewLevel = mainViewLevel

        solitaryViewModel.clearDataSource()
        imageModels = solitaryViewModel.imageModels
        solitaryViewModel.getResults(index: mainViewLevel)
//        imageTags = solitaryViewModel.tagString

        self.imageModels = self.solitaryViewModel.imageModels
    }

    private func getImageModels() {
        solitaryViewModel.populateDataSource(imageTags: solitaryViewModel.tagString) { referenceError in
            if let referenceError = referenceError {
                //handle error
                print("\(referenceError)")
                self.alertMessageString = referenceError.errorDescription
                self.showingAlert = true
                return
            }

//            self.imageModels = self.solitaryViewModel.imageModels
//            DispatchQueue.main.async {
                self.imageModels = self.solitaryViewModel.imageModels
//            }
        }
//        let urlString = solitaryViewModel.userSettings.getFullUrlString(tags: imageTags)
//        self.solitaryViewModel.dataManager.populateDataSource(urlString: urlString,
//                                            useRxSwift: userSettings.useRxSwift,
//                                            networkingType: userSettings.networkingType) { referenceError in
//            if let referenceError = referenceError {
//                //handle error
//                print("\(referenceError)")
//                self.alertMessageString = referenceError.errorDescription
//                self.showingAlert = true
//                return
//            }
//
//            self.imageModels = self.solitaryViewModel.dataManager.imageModels
//        }
    }

//    private func getTitle() -> String {
//        if mainViewLevel == 0 {
//            return "Starting Images"
//        } else {
//            return imageTags
//        }
//    }
//
//    private func getBackButtonText() -> String {
//        if mainViewLevel == 0 {
//            return settingsButtonText
//        } else {
//            return solitaryViewModel.dataManager.getLastTagsString(index: mainViewLevel - 1)
//        }
//    }
//
//    private func getRightButtonText() -> String {
//        if mainViewLevel < userSettings.maxNumberOfLevels {
//            return pickTagsButtonText
//        } else {
//            return startButtonText
//        }
//    }
}

struct SolitaryMainView_Previews: PreviewProvider {
    static var previews: some View {
//        let userSettings = UserDefaultsManager.getUserSettings()
//        return SolitaryMainView(userSettings: userSettings, mainViewLevel: 0, imageTags: userSettings.initialTags)
        return SolitaryMainView()
    }
}
