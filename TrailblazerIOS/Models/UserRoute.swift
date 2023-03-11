//
//  UserRoute.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/27/22.
//

import Foundation

struct UserRoute: Codable {
    var id : String?
    var destinationTrailName : String
    var originTrailName : String
    var dateMade: String
    var timeTook: Int
    var userID : String?
    var user : User?
}
