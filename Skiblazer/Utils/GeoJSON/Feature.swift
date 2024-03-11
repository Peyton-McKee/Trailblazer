//
//  Feature.swift
//  Snowport
//
//  Created by Peyton McKee on 1/3/24.
//

import Foundation

struct Feature {
    var geometry: Geometry
    var name: String
}

extension Feature: Identifiable, Hashable {
    static func == (lhs: Feature, rhs: Feature) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    var id: UUID {
        return UUID()
    }
}
