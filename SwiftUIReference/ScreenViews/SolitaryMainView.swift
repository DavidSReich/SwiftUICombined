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

    //inject this?
//    @State private var solitaryViewModel = SolitaryViewModel(dataManager: DataManager(),
//                                                             userSettings: UserDefaultsManager.getUserSettings())
    @State var solitaryViewModel: SolitaryViewModel

    @State private var imageModels = [ImageDataModelProtocolWrapper]()
    @State private var nextImageTags = ""
    @State private var showingSelectorView = false
    @State private var showingSettingsView = false
    @State private var settingsChanged = true

    @State private var showingAlert = false
    @State private var alertMessageString: String?

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
                self.goBack(toTop: false)
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
                self.goBack(toTop: true)
            }
        }
        .sheet(isPresented: $showingSelectorView, onDismiss: {
            if !self.nextImageTags.isEmpty {
                self.solitaryViewModel.saveResults(nextImageTags: self.nextImageTags)
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

        self.getImageModels()
    }

    private func goBack(toTop: Bool) {
        if toTop {
            solitaryViewModel.goBackToTop()
        } else {
            solitaryViewModel.goBackOneLevel()
        }

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

            self.imageModels = self.solitaryViewModel.imageModels
        }
    }
}

struct SolitaryMainView_Previews: PreviewProvider {
    static var previews: some View {
//        let userSettings = UserDefaultsManager.getUserSettings()
//        return SolitaryMainView(userSettings: userSettings, mainViewLevel: 0, imageTags: userSettings.initialTags)
        let solitaryViewModel = SolitaryViewModel(dataManager: DataManager(),
                                                                 userSettings: UserDefaultsManager.getUserSettings())

        return SolitaryMainView(solitaryViewModel: solitaryViewModel)
    }
}
