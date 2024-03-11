//
//  GeometryContainer.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/10/24.
//

import SwiftUI

struct GeometryContainer<Content: View>: View {
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            content()
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
        }
    }
}
