//
//  TrailSelectorSection.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/8/24.
//

import SwiftUI

struct TrailSelectorSection: View {
    var title: String
    var trails: [Trail]
    var onTrailSelected: (Trail) -> Void

    var body: some View {
        if !self.trails.isEmpty {
            Section(self.title) {
                ForEach(self.trails) { trail in
                    TrailSelectorRow(trail: trail, onTrailSelected: onTrailSelected)
                }
            }
        }
    }
}
