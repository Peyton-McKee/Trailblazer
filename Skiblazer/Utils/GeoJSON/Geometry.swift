//
//  Geometry.swift
//  Snowport
//
//  Created by Peyton McKee on 1/3/24.
//

import CoreLocation

struct Geometry: Identifiable {
    var id = UUID()
    var coordinates: [CLLocationCoordinate2D]
}

extension Geometry: Decodable {
    private enum CodingKeys: String, CodingKey {
        case coordinates
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawCoordinates = try values.decode([[Double]].self, forKey: .coordinates)
        self.coordinates = rawCoordinates.map { .init(latitude: $0[1], longitude: $0[0]) }
    }
}
