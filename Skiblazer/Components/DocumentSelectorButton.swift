//
//  DocumentSelectorButton.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

struct DocumentSelectorButton: View {
    var title: String
    
    var onSelect: (URL) -> Void
    
    init(_ title: String, onSelect: @escaping (URL) -> Void) {
        self.title = title
        self.onSelect = onSelect
    }
    
    @State var showDocumentPicker = false
    
    @State var selected = false
    
    var body: some View {
        HStack {
            SkiblazerButton(self.title) {
                self.showDocumentPicker.toggle()
            }
            .sheet(isPresented: self.$showDocumentPicker) {
                DocumentPicker([.json]) { url in
                    self.selected = true
                    self.onSelect(url)
                }
            }
            
            if self.selected {
                Image(systemName: SystemImageName.checkmark.rawValue)
                    .foregroundStyle(.green)
            } else {
                Image(systemName: SystemImageName.close.rawValue)
                    .foregroundStyle(.red)
            }
        }
    }
}
