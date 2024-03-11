//
//  Theme.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/16/23.
//

import Foundation
import UIKit

extension UIColor {
    struct Theme {
        static let easyColor =  UIColor(hex: "#00be00ff")!
        static let intermediateColor = UIColor(hex: "#0000beff")!
        static let advancedColor = UIColor.gray
        static let expertsOnlyColor = UIColor.black
        static let liftsColor = UIColor(hex: "#720000FF")!
        static let terrainParksColor = UIColor(hex: "#F28C28ff")!
    }
}

extension UIFont {
    struct Theme {
        static let markerFelt = UIFont(name: "markerfelt-wide", size: 20)
    }
}
