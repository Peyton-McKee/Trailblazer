//
//  UserLocation.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/27/22.
//

import Foundation

struct UserLocation: Codable {
    var id : String?
    var latitude : Double
    var longitude : Double
    var timeReported: String
    var userID : String?
    var user : User?
}
