//
//  NotificationUtils.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/24/22.
//

import Foundation

class Container {
    private(set) var urls: [URL] = []
    func add() {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "selectedTrail"),
            object: self)
    }
}
