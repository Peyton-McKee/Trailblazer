//
//  TrailSelectorRow.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/8/24.
//

import SwiftUI

struct TrailSelectorRow: View {
    var trail: Trail

    var onTrailSelected: (Trail) -> Void

    var body: some View {
        SkiblazerLabel(self.trail.title)
            .onTapGesture {
                self.onTrailSelected(self.trail)
            }
            .foregroundStyle(Color(self.trail.color))
    }
}
