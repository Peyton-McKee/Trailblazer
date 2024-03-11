//
//  ToastView.swift
//  Snowport
//
//  Created by Peyton McKee on 1/2/24.
//

import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            Text(self.message)
                .font(Font.caption)
                .foregroundColor(Color(.label))
            
            Spacer(minLength: 10)
            
            Button {
                self.onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .cornerRadius(8)
        .background(Color(.secondarySystemBackground))
        .border(style.themeColor)
        .padding(.horizontal, 16)
    }
}

#Preview {
    ToastView(style: .success, message: "Success!", onCancelTapped: {})
}
