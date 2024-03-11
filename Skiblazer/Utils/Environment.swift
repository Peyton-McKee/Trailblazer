//
//  Environment.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/8/24.
//

import SwiftUI

// Define your custom environment key
struct CustomEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

// Define an extension to the EnvironmentValues struct to provide a typed accessor for your custom environment key
extension EnvironmentValues {
    var keyboardFocused: Bool {
        get { self[CustomEnvironmentKey.self] }
        set { self[CustomEnvironmentKey.self] = newValue }
    }
}

class CustomEnvironment: ObservableObject {
    @Published var keyboardFocused = false
}
