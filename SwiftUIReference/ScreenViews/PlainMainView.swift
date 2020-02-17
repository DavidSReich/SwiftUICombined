//
//  PlainMainView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 8/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

// swiftlint:disable multiple_closures_with_trailing_closure

struct PlainMainView: View {

    let dataManager = DataManager()

    @State private var imageModels = [ImageDataModelProtocolWrapper]()
    @State private var nextImageTags = ""
    @State private var showingSelectorView = false
    @State private var gotoAnotherMainView = false
    @State private var showingSettingsView = false
    @State private var settingsChanged = true

    @State private var showingAlert = false

    @State var userSettings: UserSettings

    let mainViewLevel: Int
    @State var imageTags: String

    @State private var alertMessageString: String?

    let settingsButtonText = "Settings"
    let pickTagsButtonText = "Pick Tags"
    let startButtonText = "Start"

    var body: some View {
        Group {
            if mainViewLevel == 0 {
                NavigationView {
                    mainView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            } else {
                mainView()
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Something went wrong!"),
                  message: Text( alertMessageString ?? "Unknown error!!??!!"),
                  dismissButton: .default(Text("Done")))
        }
    }

    private func mainView() -> some View {
        VStack {
            baseListWithNavBarView()
            .navigationBarTitle(Text(getTitle()), displayMode: .inline)
            .onAppear(perform: loadEverything)

            NavigationLink(destination: PlainMainView(userSettings: userSettings,
                                                      mainViewLevel: mainViewLevel + 1,
                                                      imageTags: nextImageTags),
                           isActive: $gotoAnotherMainView) {
                            EmptyView()
            }.hidden()
        }
    }

    private func baseListWithNavBarView() -> some View {
        Group {
            if mainViewLevel == 0 {
                basicImageList()
                .navigationBarItems(
                    leading: Button(getBackButtonText()) {
                        self.settingsChanged = false
                        self.showingSettingsView = true
                    }
                    .sheet(isPresented: $showingSettingsView, onDismiss: {
                        self.loadEverything()
                    }) {
                        SettingsView(isPresented: self.$showingSettingsView,
                                     userSettings: self.$userSettings,
                                     tags: self.$imageTags,
                                     settingsChanged: self.$settingsChanged)
                    }
                    ,
                    trailing: trailingNavigationItem()
                )
            } else {
                basicImageList()
                .navigationBarItems(
                    trailing: trailingNavigationItem()
                )
            }
        }
    }

    private func basicImageList() -> some View {
        List(imageModels.indices, id: \.self) { index in
            NavigationLink(destination: ImageView(imageModel: self.imageModels[index].imageModel)) {
                ImageRowView(imageModel: self.imageModels[index].imageModel, showOnLeft: index.isMultiple(of: 2))
            }
        }
    }

    private func trailingNavigationItem() -> some View {
        Button(getRightButtonText()) {
            if self.getRightButtonText() == self.pickTagsButtonText {
                self.nextImageTags = ""
                self.showingSelectorView = true
            } else if self.getRightButtonText() == self.startButtonText {
                print("goto start????")
                //currently not working due to SwiftUI navigation issues.
            }
        }
        .sheet(isPresented: $showingSelectorView, onDismiss: {
            if !self.nextImageTags.isEmpty {
                self.gotoAnotherMainView = true
            }
        }) {
            SelectorView(isPresented: self.$showingSelectorView,
                         selectedStrings: self.$nextImageTags,
                         allStrings: self.dataManager.tagsArray)
        }
    }

    private func loadEverything() {
        guard settingsChanged else {
            return
        }

        settingsChanged = false

        //clear and then reloadData with empty in case populateDataSource fails -
        //if it fails completely it won't call any of the completion callbacks.
        dataManager.clearDataSource()
        imageModels = dataManager.imageModels

        //need a delay so that screen can completely refresh after imageModels was reset
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.getImageModels()
        }
    }

    private func getImageModels() {
        let urlString = userSettings.getFullUrlString(tags: imageTags)
        self.dataManager.populateDataSource(urlString: urlString,
                                            useRxSwift: userSettings.useRxSwift,
                                            networkingType: userSettings.networkingType) { referenceError in
            if let referenceError = referenceError {
                //handle error
                print("\(referenceError)")
                self.alertMessageString = referenceError.errorDescription
                self.showingAlert = true
                return
            }

            self.imageModels = self.dataManager.imageModels
        }
    }

    private func getTitle() -> String {
        if mainViewLevel == 0 {
            return "Starting Images"
        } else {
            return imageTags
        }
    }

    private func getBackButtonText() -> String {
        if mainViewLevel == 0 {
            return settingsButtonText
        } else {
            return "Back"
        }
    }

    private func getRightButtonText() -> String {
        if mainViewLevel < userSettings.maxNumberOfLevels {
            return pickTagsButtonText
        } else {
            return startButtonText
        }
    }
}

struct PlainMainView_Previews: PreviewProvider {
    static var previews: some View {
        let userSettings = UserDefaultsManager.getUserSettings()
        return PlainMainView(userSettings: userSettings, mainViewLevel: 0, imageTags: userSettings.initialTags)
    }
}
