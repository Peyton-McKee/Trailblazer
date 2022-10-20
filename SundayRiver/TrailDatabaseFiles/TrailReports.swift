//
//  Trail Reports.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/11/22.
//

import Foundation
import UIKit

enum TrailReportType {
    case moguls
    case ice
    case crowded
}

struct TrailReport: Codable {
    var id : String?
    var type : String
    var location : String
}
