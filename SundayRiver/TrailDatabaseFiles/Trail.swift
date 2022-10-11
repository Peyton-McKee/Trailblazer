//
//  Trail.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/26/22.
//

import Foundation
import MapKit

struct Trail {
    let name: String
    let difficulty: String
    let annotations : [ImageAnnotation]
}

struct Lift{
    let name: String
    let annotations : [ImageAnnotation]
}
