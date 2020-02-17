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

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Registration").font(.subheadline)) {
                    HStack {
                        Text("GIPHY API Key")
                        TextField("", text: $userSettings.giphyAPIKey).multilineTextAlignment(.trailing)
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
                        TextField("", text: $userSettings.initialTags).multilineTextAlignment(.trailing)
                    }
                }
                Section(header: Text("RxSwift").font(.subheadline)) {
                    Toggle(isOn: $userSettings.useRxSwift) {
                        Text("Use RxSwift")
                    }
                    .accessibility(identifier: "toggle ID")
                    .accessibility(hint: Text("toggle hint"))
                    .accessibility(label: Text("toggle label"))
                    .accessibility(value: Text("toggle value"))
                }
                Section(header: Text("Networking").font(.subheadline)) {
                    Picker(selection: $userSettings.networkingType, label: EmptyView()) {
                        Text("Alamofire").tag(UserSettings.NetworkingType.alamoFire)
                        Text("URLSession").tag(UserSettings.NetworkingType.urlSession)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Limits").font(.subheadline)) {
                    StepperField(title: "Max # of images",
                                 value: $userSettings.maxNumberOfImages,
                                 range: 5...30,
                                 accessibilityID: "imageStepper")
                    StepperField(title: "Max # of levels",
                                 value: $userSettings.maxNumberOfLevels,
                                 range: 5...20,
                                 accessibilityID: "levelStepper")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Select tags"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                },
                trailing:
                HStack {
                    Button("Reset") {
                        let defaultSettings = UserSettings.getDefaultUserSettings()
                        self.userSettings.initialTags = defaultSettings.initialTags
                        self.userSettings.maxNumberOfImages = defaultSettings.maxNumberOfImages
                        self.userSettings.maxNumberOfLevels = defaultSettings.maxNumberOfLevels
                        self.userSettings.networkingType = defaultSettings.networkingType
                        self.userSettings.useRxSwift = defaultSettings.useRxSwift
                    }
                    Divider()
                    Button("Apply") {
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
                                                  maxNumberOfLevels: 7,
                                                  useRxSwift: false,
                                                  networkingType: .urlSession)
    @State static var tags = "weather"

    static var previews: some View {
        SettingsView(isPresented: $isPresented, userSettings: $userSettings, tags: $tags, settingsChanged: $settingsChanged)
    }
}

struct StepperField: View {
    var title: String
    var value: Binding<Int>
    var range: ClosedRange<Int>
    var accessibilityID: String

    var body: some View {
        Stepper(value: value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text("\(value.wrappedValue)")
                    .accessibility(identifier: "value" + accessibilityID)
            }
        }
        .accessibility(identifier: accessibilityID)
        .accessibility(hint: Text("stepper hint"))
        .accessibility(label: Text("stepper label"))
        .accessibility(value: Text("stepper value"))
    }
}
