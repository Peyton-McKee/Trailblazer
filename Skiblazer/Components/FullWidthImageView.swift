//
//  FullWidthImageView.swift
//  Snowport
//
//  Created by Peyton McKee on 1/27/24.
//

import SwiftUI

struct FullWidthImageView: View {
    var image: UIImage? = nil
    var imageKey: String? = nil
    var label: () -> AnyView
    var onSelect: () -> Void
    var height: CGFloat = 150
    
    init(_ imageKey: String, _ titleKey: String, _ onSelect: @escaping () -> Void = {}, height: CGFloat = 150) {
        self.imageKey = imageKey
        self.onSelect = onSelect
        self.label = {AnyView(SkiblazerLabel(titleKey)
            .padding(.leading, 8)
            .fontWeight(.bold)
            .foregroundStyle(.white))}
        self.height = height
    }
    
    init(_ image: UIImage, _ titleKey: String, _ onSelect: @escaping () -> Void = {}, height: CGFloat = 150) {
        self.image = image
        self.onSelect = onSelect
        self.label = {AnyView(SkiblazerLabel(titleKey)
            .padding(.leading, 8)
            .fontWeight(.bold)
            .foregroundStyle(.white))}
        self.height = height
    }
    
    init(_ imageKey: String, _ label: @escaping () -> AnyView, _ onSelect: @escaping () -> Void = {}, height: CGFloat = 150) {
        self.imageKey = imageKey
        self.onSelect = onSelect
        self.label = label
        self.height = height
    }
    
    init(_ image: UIImage, _ label: @escaping () -> AnyView, _ onSelect: @escaping () -> Void = {}, height: CGFloat = 150) {
        self.image = image
        self.onSelect = onSelect
        self.label = label
        self.height = height
    }
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.init(.white), .init(.black)]), startPoint: .top, endPoint: .bottom)
            .frame(height: self.height)
            .opacity(0.6)
            .overlay(alignment: .bottomLeading) {
                label()
            }
            .background(
                Group {
                    if let image = self.image {
                        AsyncImageLoaderView(viewModel: .init(image: image), aspectRatio: .fill)
                    } else if let imageKey = self.imageKey {
                        AsyncImageLoaderView(viewModel: .init(imageKey: imageKey), aspectRatio: .fill)
                    } else {
                        EmptyView()
                    }
                })
            .onTapGesture {
                self.onSelect()
            }
    }
}

