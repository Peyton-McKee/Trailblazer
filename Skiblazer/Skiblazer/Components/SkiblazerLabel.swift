//
//  SnowportLabel.swift
//  Snowport
//
//  Created by Peyton McKee on 12/23/23.
//

import SwiftUI

struct SkiblazerLabel: View {
    var title: String
    var fontSize: CGFloat = 24
    var fontName: FontName = .roboto
    var systemImageName: SystemImageName?
    
    init(_ title: String, fontSize: CGFloat? = 24, fontName: FontName = .roboto, systemImageName: SystemImageName? = nil) {
        if let fontSize = fontSize {
            self.fontSize = fontSize
        }
        self.title = title
        self.fontName = fontName
        self.systemImageName = systemImageName
    }
    
    var body: some View {
        if let systemImageName = self.systemImageName {
            Label(self.title, systemImage: systemImageName.rawValue)
                .font(.custom(self.fontName.rawValue, size: self.fontSize))
        } else {
            Text(self.title)
                .font(.custom(self.fontName.rawValue, size: self.fontSize))
        }
    }
}

#Preview {
    SkiblazerLabel("Hello World", systemImageName: .checkmark)
}
