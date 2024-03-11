//
//  TrailReportSelector.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/6/24.
//

import SwiftUI
import SwiftUIX

struct TrailReportSelector: View {
    var onSelect: (TrailReportType) -> Void

    var body: some View {
        List {
            ForEach(TrailReportType.allCases, id: \.self) { report in
                TrailReportRow(trailReportType: report)
                    .onTapGesture {
                        self.onSelect(report)
                    }
            }
        }
    }
}
