//
//  RouteSampleView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/8/24.
//

import SwiftUI

struct RouteSampleView: View {
    var trails: [Trail]
    var trailReports: [TrailReport]

    var onLetsGoPressed: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            if let firstTrail = trails.first, let lastTrail = trails.last {
                SkiblazerLabel("\(firstTrail.title) - \(lastTrail.title)")
                    .font(.title)
                    .fontWeight(.bold)
            }

            VStack(spacing: 5) {
                if trails.count >= 2 {
                    SkiblazerLabel("\(trails[0].title); \(trails[1].title)", fontSize: 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if trails.count > 3 {
                        SkiblazerLabel("See More Details", fontSize: 14)
                            .onTapGesture {}
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }

            if !self.trailReports.isEmpty {
                SkiblazerLabel("Caution:  \(self.trailReports.map { $0.type.formatted }.joined(separator: ", "))", fontSize: 14)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            VStack(spacing: 0) {
                Spacer(minLength: 0)

                SkiblazerButton("Let's Go!") {
                    self.onLetsGoPressed()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}
