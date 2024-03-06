//
//  AppContext.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

class AppContext: ObservableObject {
    static var shared = AppContext()
    @Published var selectedGraph: EdgeWeightedDigraph<Point> = .init()
    @Published var selectedMap: Map?
}
