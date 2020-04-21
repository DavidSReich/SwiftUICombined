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

    @ObservedObject var solitaryViewModel: SolitaryViewModel

    @State private var nextImageTags = ""
    @State private var showingSelectorView = false
    @State private var showingSettingsView = false
    @State private var settingsChanged = true

    @State private var showingAlert = false
    @State private var alertMessageString: String?

    @State private var isLoading = false

    @State private var alreadyAppeared = false  //has to be @State so it can be changed

    // body used to be a lot more complicated, but still is helped by breaking it down into several funcs
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    self.mainView(geometry: geometry).opacity(self.isLoading ? 0.25 : 1.0)
                }

                Group {
                    if isLoading {
                        ActivityIndicatorView(style: .large)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showingAlert) {
            if UserDefaultsManager.hasAPIKey() {
                return Alert(title: Text("Something went wrong!"),
                      message: Text( alertMessageString ?? "Unknown error!!??!!"),
                      dismissButton: .default(Text("OK ... I guess")))
            } else {
                return Alert(title: Text("API Key is missing"),
                      message: Text("Go to Settings to enter an API Key"),
                      dismissButton: .default(Text("OK ... I guess")))
            }
        }
    }

    private func mainView(geometry: GeometryProxy) -> some View {
        VStack {
            baseListWithNavBarView(geometry: geometry)
            .navigationBarTitle(Text(solitaryViewModel.title), displayMode: .inline)
            .onAppear(perform: onAppearLoadEverything)
        }
    }

    private func onAppearLoadEverything() {
        if alreadyAppeared {
            return
        }

        alreadyAppeared = true
        loadEverything()
    }

    private func baseListWithNavBarView(geometry: GeometryProxy) -> some View {
        basicImageList()
        .navigationBarItems(
            leading: leadingNavigationItem(geometry: geometry),
            trailing: trailingNavigationItem()
        )
    }

    private func basicImageList() -> some View {
        List(solitaryViewModel.imageModels.indices, id: \.self) { index in
            NavigationLink(destination: ImageView(imageModel: self.solitaryViewModel.imageModels[index].imageModel)) {
                ImageRowView(imageModel: self.solitaryViewModel.imageModels[index].imageModel, showOnLeft: index.isMultiple(of: 2))
            }
        }
    }

    private func leadingNavigationItem(geometry: GeometryProxy) -> some View {
        // swiftlint:disable multiple_closures_with_trailing_closure
        Button(action: {
            if self.solitaryViewModel.isBackButtonSettings {
                self.settingsChanged = false
                self.showingSettingsView = true
            } else {
                self.goBack(toTop: false)
            }
        }) {
            //it appears that some of these settings are carried to the navigation title !!!
            Text(solitaryViewModel.backButtonText).frame(width: geometry.size.width * 0.25).lineLimit(1)
        }
        .sheet(isPresented: $showingSettingsView, onDismiss: {
            if self.settingsChanged {
                self.solitaryViewModel.clearDataSource()
                self.loadEverything()
            }
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
                self.solitaryViewModel.tagString = self.nextImageTags
                self.loadEverything()
            }
        }) {
            SelectorView(isPresented: self.$showingSelectorView,
                         selectedStrings: self.$nextImageTags,
                         allStrings: self.solitaryViewModel.tagsArray)
        }
    }

    private func loadEverything() {
        // reset
        solitaryViewModel.imageModels.removeAll()

        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.solitaryViewModel.populateDataSource(imageTags: self.solitaryViewModel.tagString) { referenceError in
                self.isLoading = false
                if let referenceError = referenceError {
                    //handle error
                    print("\(referenceError)")
                    self.alertMessageString = referenceError.errorDescription
                    self.showingAlert = true
                    return
                }
            }
        }
    }

    private func goBack(toTop: Bool) {
        if toTop {
            solitaryViewModel.goBackToTop()
        } else {
            solitaryViewModel.goBackOneLevel()
        }
    }
}

struct SolitaryMainView_Previews: PreviewProvider {
    static var previews: some View {
        let solitaryViewModel = SolitaryViewModel(dataSource: DataSource(networkService: MockNetworkService()),
                                                  userSettings: UserDefaultsManager.getUserSettings())

        return SolitaryMainView(solitaryViewModel: solitaryViewModel)
    }
}
