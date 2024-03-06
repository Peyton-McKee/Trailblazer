//
//  DocumentPicker.swift
//  Snowport
//
//  Created by Peyton McKee on 12/27/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    private var onSelection: (_ url: URL) -> Void
    private var allowedContentTypes : [UTType]
    
    init(_ allowedContentTypes: [UTType], onSelection: @escaping (_ url: URL) -> Void) {
        self.allowedContentTypes = allowedContentTypes
        self.onSelection = onSelection
    }

    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(parent: self, onSelection: self.onSelection)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: self.allowedContentTypes)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        var onSelection: (_ url: URL) -> Void
        
        init(parent: DocumentPicker, onSelection: @escaping (_ url: URL) -> Void) {
            self.parent = parent
            self.onSelection = onSelection
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            self.onSelection(urls.first!)
        }
    }
    
}
