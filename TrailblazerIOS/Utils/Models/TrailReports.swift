//
//  Trail Reports.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/11/22.
//

import Foundation
import UIKit

enum TrailReportType: String {
    case moguls = "Moguls"
    case ice = "Icy"
    case crowded = "Crowded"
    case thinCover = "Thin Cover"
    case longLiftLine = "Long Lift Line"
    case snowmaking = "Snowmaking"
}

struct TrailReport: Codable {
    var id : String?
    var type : String
    var latitude : Double
    var longitude: Double
    var dateMade: String
    var trailMadeOn: String
    var userID : String?
}
