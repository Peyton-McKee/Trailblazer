//
//  AdminView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import PhotosUI
import SwiftUI

struct AdminView: View {
    init() {
        print("init")
    }

    @ObservedObject var viewModel: AdminViewModel = .init()
    
    @State var photoPickerItem: PhotosPickerItem?
    @State var isPhotoSelected = false
    
    var body: some View {
        AsyncContentView(source: self.viewModel) { _ in
            Form {
                Section("New Map") {
                    DocumentSelectorButton("Upload Easy Trails") { url in
                        self.viewModel.easyTrailsJsonUrl = url
                    }
                
                    DocumentSelectorButton("Upload Intermediate Trails") {
                        url in
                        self.viewModel.intermediateTrailsJsonUrl = url
                    }
                
                    DocumentSelectorButton("Upload Advanced Trails") { url in
                        self.viewModel.advancedTrailsJsonUrl = url
                    }
                
                    DocumentSelectorButton("Upload Expert Trails") { url in
                        self.viewModel.expertTrailsJsonUrl = url
                    }
                
                    DocumentSelectorButton("Upload Terrain Parks") { url in
                        self.viewModel.terrainParksJsonUrl = url
                    }
                
                    DocumentSelectorButton("Upload Trail Connectors") { url in
                        self.viewModel.connectorsJsonUrl = url
                    }
                
                    DocumentSelectorButton("Upload Lifts") { url in
                        self.viewModel.liftsJsonUrl = url
                    }
                
                    TextField("Enter Map Name", text: self.$viewModel.mapName)
                
                    CustomPhotoPicker(photoPickerItem: self.photoPickerItem, isPhotoSelected: self.isPhotoSelected) { result in
                        self.viewModel.selectPhoto(result)
                    }
                
                    FormSubmitButton(submissionText: .save) {
                        DispatchQueue.main.async {
                            self.viewModel.saveMap()
                        }
                    }
                }
            }
        }
        .toastView(toast: self.$viewModel.toast)
    }
}
