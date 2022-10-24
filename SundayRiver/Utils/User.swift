//
//  User.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/4/22.
//

import Foundation

enum userStatus
{
    case guest
    case member
}

struct User : Codable{
    var id : String?
    var userName : String?
    var password : String?
    var trailReports: [TrailReport]?
}

