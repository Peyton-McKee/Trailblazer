//
//  MapOverlay.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/25/22.
//

import Foundation
import MapKit

class MapOverlay: MKTileOverlay
{
    override func url(forTilePath path: MKTileOverlayPath) -> URL {
        let tileUrl =
        "https://tile.mapzen.com/mapzen/terrain/v1/terrarium/\(path.z)/\(path.x)/\(path.y).png"
        return URL(string: tileUrl)!
      }
//    override func url(forTilePath path: MKTileOverlayPath) -> URL {
//        print(path)
//      let tilePath = Bundle.main.url(
//        forResource: "\(path.y)",
//        withExtension: "png",
//        subdirectory: "Tiles/ConfirmedTiles/\(path.z)/\(path.x)",
//        localization: nil)
//
//      if let tile = tilePath {
//        return tile
//      } else {
//        return Bundle.main.url(
//          forResource: "parchment",
//          withExtension: "jpeg",
//          subdirectory: "Tiles/ConfirmedTiles",
//          localization: nil)!
//        // swiftlint:disable:previous force_unwrapping
//      }
//    }
}
//command to get tile pictures
//print("curl -o z/x/y\(MapOverlay.count).png https://tile.openstreetmap.org/\(path.z)/\(path.x)/\(path.y).png")
