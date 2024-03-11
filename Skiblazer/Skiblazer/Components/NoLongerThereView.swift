//
//  NoLongerThereView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/11/24.
//

import SwiftUI

struct NoLongerThereView: View {
    var trailReport: TrailReport
    var onNoLongerTherePressed: (TrailReport) -> Void
    var onCancelPressed: () -> Void

    var body: some View {
        VStack (alignment: .leading) {
            SkiblazerLabel("Remove \(self.trailReport.type.formatted)")
            
            Spacer()
            
            HStack {
                SkiblazerButton("Cancel") {
                    self.onCancelPressed()
                }
                
                SkiblazerButton("No Longer There") {
                    self.onNoLongerTherePressed(trailReport)
                }
            }
        }
    }
}
