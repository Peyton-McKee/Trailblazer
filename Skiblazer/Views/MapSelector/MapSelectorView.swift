//
//  MapSelectorView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

struct MapSelectorView: View {
    @ObservedObject var viewModel: MapSelectorViewModel = .init()

    @Binding var path: [HomeNavigation]
    var body: some View {
        AsyncContentView(source: self.viewModel) { props in
            Group {
                if props.maps.isEmpty {
                    SkiblazerLabel("No Maps Found")
                } else {
                    List {
                        ForEach(props.maps, id: \.id) { map in
                            ZStack {
                                FullWidthImageView(map.storageKeyPrefix + "image", map.name) {
                                    AppContext.shared.selectedMap = map
                                    self.path.append(.mapView(map: map))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select a Map")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
