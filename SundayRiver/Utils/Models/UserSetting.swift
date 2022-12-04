//
//  UserSetting.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/2/22.
//

import Foundation

enum RoutingType : String {
    case easiest = "Easiest"
    case quickest = "Quickest"
    case leastDistance = "Least Distance"
}

struct UserSetting : Codable {
    var preferredRoutingType: String
    var preferredAlerts : [String]
}
