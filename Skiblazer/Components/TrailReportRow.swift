//
//  TrailReportRow.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/6/24.
//

import SwiftUI

struct TrailReportRow: View {
    var trailReportType: TrailReportType

    var body: some View {
        HStack {
            Image(systemName: self.trailReportType.icon.rawValue)
                .foregroundColor(.primary)
                .font(.system(size: 24, weight: .bold))

            SkiblazerLabel(self.trailReportType.formatted)
        }
    }
}
