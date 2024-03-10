//
//  SkiblazerApp.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSPinpointPushNotificationsPlugin
import AWSS3StoragePlugin
import Foundation
import SwiftUI
@_spi(Experimental) import MapboxMaps

@main
struct SkiblazerApp: App {
    @ObservedObject var environment = CustomEnvironment()

    init() {
        MapboxOptions.accessToken = ValidationUtils.getMapBoxAccessToken()
    }

    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
            print("Initialized Amplify")
        } catch {
            // simplified error handling for the tutorial
            print("Could not initialize Amplify: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    self.configureAmplify()
                }
                .environment(\.keyboardFocused, self.environment.keyboardFocused)
                .environmentObject(environment)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        // the Spacer will push the Done button to the far right of the keyboard as pictured.
                        Spacer()

                        Button(action: {
                            environment.keyboardFocused = false
                        }, label: {
                            Text("Done")
                        })
                    }
                }
        }
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}
