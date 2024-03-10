//
//  TrailReportTypeExtension.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/6/24.
//

import UIKit

extension TrailReportType {
    var formatted: String {
        switch self {
        case .icy:
            return "Icy"
        case .moguls:
            return "Moguls"
        case .powder:
            return "Powder"
        case .thinCover:
            return "Thin Cover"
        }
    }

    var pointString: String {
        switch self {
        case .icy:
            return "❄️\n Icy"
        case .moguls:
            return "☁️\n Moguls"
        case .powder:
            return "🌨️\n Powder"
        case .thinCover:
            return "🍂\n Thing Cover"
        }
    }

    var icon: SystemImageName {
        switch self {
        case .icy:
            return SystemImageName.snowflake
        case .moguls:
            return SystemImageName.moguls
        case .powder:
            return SystemImageName.powder
        case .thinCover:
            return SystemImageName.thincover
        }
    }

    var color: UIColor {
        switch self {
        case .icy:
            return .blue
        case .moguls:
            return .black
        case .powder:
            return .white
        case .thinCover:
            return .brown
        }
    }
}
