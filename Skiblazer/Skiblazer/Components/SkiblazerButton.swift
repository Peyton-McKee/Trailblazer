//
//  SkiblazerButton.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

struct SkiblazerButton: View {
    var text: String
    var action: () -> Void

    init(_ text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(self.text) {
            self.action()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundStyle(.white)
        .background(Color(.darkGray).opacity(0.8))
        .clipShape(.buttonBorder)
    }
}
