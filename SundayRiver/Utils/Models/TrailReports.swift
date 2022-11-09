//
//  Trail Reports.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/11/22.
//

import Foundation
import UIKit

enum TrailReportType: Codable {
    case moguls
    case ice
    case crowded
    case thinCover
}

struct TrailReport: Codable {
    var id : String?
    var type : String
    var latitude : Double
    var longitude: Double
    var dateMade: String
    var trailMadeOn: String
    var userID : String?
    var user : User?
}
