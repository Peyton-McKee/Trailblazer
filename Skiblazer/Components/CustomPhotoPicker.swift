//
//  CustomPhotoPicker.swift
//  Snowport
//
//  Created by Peyton McKee on 1/7/24.
//

import PhotosUI
import SwiftUI

struct CustomPhotoPicker: View {
    @State var photoPickerItem: PhotosPickerItem?
    @State var isPhotoSelected: Bool

    var onChange: (Result<Data?, any Error>) -> Void

    var body: some View {
        PhotosPicker(selection: self.$photoPickerItem, matching: .images) {
            SkiblazerLabel(self.isPhotoSelected ? "Photo Selected" : "Select a Photo", fontSize: 18, systemImageName: self.isPhotoSelected ? .checkmark : .photo)
        }
        .onChange(of: self.photoPickerItem) {
            self.isPhotoSelected = true
            self.photoPickerItem?.loadTransferable(type: Data.self) { result in
                self.onChange(result)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .controlSize(.large)
    }
}
