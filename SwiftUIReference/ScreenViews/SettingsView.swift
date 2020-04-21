//
//  SettingsView.swift
//  SwiftUIReference
//
//  Created by David S Reich on 7/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import SwiftUI

/*
 Accessibility stuff set below trying to make it possible to do "useful" UITests.
 This does not appear to be possible with the current versions of Xcode, tools, and macOS.
 */

struct SettingsView: View {

    @Binding var isPresented: Bool
    @Binding var userSettings: UserSettings
    @Binding var tags: String
    @Binding var settingsChanged: Bool

    @State private var showingInfo = false
    @State private var enabledLink = false
    @State private var dummyBool = false

    @State private var initialTags = ""
    @State private var giphyAPIKey = ""
    @State private var maxNumberOfImages = 5
    @State private var maxNumberOfLevels = 5

    private func loadSettings() {
        initialTags = userSettings.initialTags
        giphyAPIKey = userSettings.giphyAPIKey
        maxNumberOfImages = userSettings.maxNumberOfImages
        maxNumberOfLevels = userSettings.maxNumberOfLevels
    }

    private func loadDefaultSettings() {
        let defaultSettings = UserSettings.getDefaultUserSettings()
        self.userSettings.initialTags = defaultSettings.initialTags
        self.userSettings.maxNumberOfImages = defaultSettings.maxNumberOfImages
        self.userSettings.maxNumberOfLevels = defaultSettings.maxNumberOfLevels

        loadSettings()
    }

    private func packSettings() {
        userSettings.initialTags = initialTags
        userSettings.giphyAPIKey = giphyAPIKey
        userSettings.maxNumberOfImages = maxNumberOfImages
        userSettings.maxNumberOfLevels = maxNumberOfLevels
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Registration").font(.subheadline)) {
                    HStack {
                        Text("GIPHY API Key")
                        TextField("", text: $giphyAPIKey).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        //trick to display a NavigationLink accessory chevron
                        NavigationLink(destination: EmptyView(), isActive: self.$enabledLink) {
                            HStack {
                                Text("Get your GIPHY key here ...")
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            if let url = URL(string: "https://developers.giphy.com/dashboard/?create=true") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    HStack {
                        Text("To use GIPHY in this app you need to create a GIPHY account, " +
                            "and then create an App there to get an API Key.")
                        Spacer()
                    }
                }
                Section(header: Text("Tags").font(.subheadline)) {
                    HStack {
                        Text("Starting Tags")
                        TextField("", text: $initialTags).multilineTextAlignment(.trailing)
                            .accessibility(identifier: "TagsTextField")
                    }
                }
                Section(header: Text("Limits").font(.subheadline)) {
                    StepperField(title: "Max # of images",
                                 value: $maxNumberOfImages,
                                 range: 5...30,
                                 accessibilityLabel: "Max number of images")
                    StepperField(title: "Max # of levels",
                                 value: $maxNumberOfLevels,
                                 range: 5...20,
                                 accessibilityLabel: "Max number of levels")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                },
                trailing:
                HStack {
                    Button("Reset") {
                        self.loadDefaultSettings()
                    }
                    Divider()
                    Button("Apply") {
                        self.packSettings()
                        let oldSettings = UserDefaultsManager.getUserSettings()
                        if oldSettings != self.userSettings {
                            UserDefaultsManager.saveUserSettings(userSettings: self.userSettings)
                            self.tags = self.userSettings.initialTags
                            self.settingsChanged = true
                        }
                        self.isPresented = false
                    }
                }
            )
                .onAppear(perform: loadSettings)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var isPresented = true
    @State static var settingsChanged = false
    @State static var userSettings = UserSettings(initialTags: "weather",
                                                  giphyAPIKey: "apiapiKeyKey",
                                                  maxNumberOfImages: 7,
                                                  maxNumberOfLevels: 7)
    @State static var tags = "weather"

    static var previews: some View {
        SettingsView(isPresented: $isPresented, userSettings: $userSettings, tags: $tags, settingsChanged: $settingsChanged)
    }
}

struct StepperField: View {
    var title: String
    var value: Binding<Int>
    var range: ClosedRange<Int>
    var accessibilityLabel: String

    var body: some View {
        Stepper(value: value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value.wrappedValue)")
            }
        }
        .accessibility(label: Text(accessibilityLabel))
        .accessibility(value: Text("\(value.wrappedValue)"))
        // During UITest the accessibility label overrides the visible label and it isn't possible to test what the user actually sees.
    }
}
