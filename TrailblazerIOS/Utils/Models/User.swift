//
//  User.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/4/22.
//

import Foundation

enum UserRole
{
    case guest
    case member
}

struct User : Codable{
    var id : String?
    var username : String
    var password : String?
    var passwordHash: String?
    var trailReports: [TrailReport]?
    var alertSettings: [String]
    var routingPreference: String
}

