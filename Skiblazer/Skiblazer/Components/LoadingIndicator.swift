//
//  LoadingIndicator.swift
//  Snowport
//
//  Created by Peyton McKee on 12/23/23.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var spinnerLength: CGFloat = 0.6
    @State private var degree: Int = 270
    
    var body: some View {
        Circle()
            .trim(from: 0.0,to: self.spinnerLength)
            .stroke(LinearGradient(colors: [.red,.blue], startPoint: .topLeading, endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 8.0,lineCap: .round,lineJoin:.round))
            .animation(Animation.easeIn(duration: 1.5).repeatForever(autoreverses: true), value: self.degree)
            .frame(width: 60,height: 60)
            .rotationEffect(Angle(degrees: Double(self.degree)))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: self.degree)
            .onAppear{
                degree = 270 + 360
                spinnerLength = 0
            }
    }
}

#Preview {
    LoadingIndicator()
}
