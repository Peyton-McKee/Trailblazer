//
//  Trail.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/26/22.
//

import Foundation
import MapKit

enum Status{
    case open
    case onHold
    case closed
    case scheduled
    case event
}

struct Trail {
    let name: String
    let difficulty: Difficulty
    let annotations : [ImageAnnotation]
}

struct Lift{
    let name: String
    let annotations : [ImageAnnotation]
}
