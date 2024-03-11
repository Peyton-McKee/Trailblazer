//
//  TrailSelectorView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/8/24.
//

import SwiftUI
import SwiftUIX

struct TrailSelectorView: View {
    var trails: [Trail]
    var onTrailSelected: (Trail) -> Void

    @State var trailsToDisplay: [Trail]

    @State var searchText: String = ""
    @EnvironmentObject var environment: CustomEnvironment

    init(trails: [Trail], onTrailSelected: @escaping (Trail) -> Void) {
        self.trails = trails
        self.onTrailSelected = onTrailSelected
        self.trailsToDisplay = trails
    }

    var body: some View {
        SearchBar("Search for a Trail", text: self.$searchText)
            .focused(self.$environment.keyboardFocused)
            .onChange(of: self.searchText) {
                if self.searchText.isEmpty {
                    self.trailsToDisplay = self.trails
                } else {
                    self.trailsToDisplay = self.trails.filter { $0.title.lowercased().contains(self.searchText.lowercased()) }
                }
            }
            .padding()

        List {
            TrailSelectorSection(title: "Easy", trails: self.trailsToDisplay.filter { $0.difficulty == .easy }, onTrailSelected: onTrailSelected)

            TrailSelectorSection(title: "Intermediate", trails: self.trailsToDisplay.filter { $0.difficulty == .intermediate }, onTrailSelected: onTrailSelected)

            TrailSelectorSection(title: "Advanced", trails: self.trailsToDisplay.filter { $0.difficulty == .advanced }, onTrailSelected: onTrailSelected)

            TrailSelectorSection(title: "Experts Only", trails: self.trailsToDisplay.filter { $0.difficulty == .expertsOnly }, onTrailSelected: onTrailSelected)

            TrailSelectorSection(title: "Terrain Parks", trails: self.trailsToDisplay.filter { $0.difficulty == .terrainPark }, onTrailSelected: onTrailSelected)

            TrailSelectorSection(title: "Lifts", trails: self.trailsToDisplay.filter { $0.difficulty == .lift }, onTrailSelected: onTrailSelected)
        }
    }
}
