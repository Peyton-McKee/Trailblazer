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
            List {
                ForEach(props.maps, id: \.id) { map in
                    ZStack {
                        FullWidthImageView(map.storageKeyPrefix + "image", map.name) {
                            self.path.append(.mapView(map: map))
                        }
                    }
                }
            }
        }
    }
}
