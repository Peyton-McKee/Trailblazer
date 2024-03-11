//
//  MapExtension.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Foundation

extension Map: Hashable {
    public static func == (lhs: Map, rhs: Map) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
