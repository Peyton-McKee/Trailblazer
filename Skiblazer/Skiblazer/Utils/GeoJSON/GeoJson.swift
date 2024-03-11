//
//  GeoJson.swift
//  Snowport
//
//  Created by Peyton McKee on 1/3/24.
//

import Foundation

struct GeoJSON: Decodable {
    private enum RootCodingKeys: String, CodingKey {
        case features
    }

    private enum FeatureCodingKeys: String, CodingKey {
        case properties
        case geometry
    }

    private(set) var features = [Feature]()

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features)

        while !featuresContainer.isAtEnd {
            let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)

            let geometry = try propertiesContainer.decode(Geometry.self, forKey: .geometry)
            let properties = try propertiesContainer.decode([String: String].self, forKey: .properties)
            let name = properties["Name"] ?? ""

            self.features.append(Feature(geometry: geometry, name: name))
        }
    }
}
