//
//  HomeNavigation.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Foundation

enum HomeNavigation: Hashable {
    case signUp
    case mapSelector
    case mapView(map: Map)
    case admin
}
