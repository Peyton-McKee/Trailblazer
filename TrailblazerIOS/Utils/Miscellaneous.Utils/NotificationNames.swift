//
//  NotificationNames.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation

extension Notification.Name
{
    enum Names
    {
        static let configureTrailSelector = Notification.Name(rawValue: "configureTrailSelector")
        static let createNotification = Notification.Name(rawValue: "createNotification")
        static let updateInitialRegion = Notification.Name(rawValue: "updateInitialregion")
        static let cancelRoute = Notification.Name(rawValue: "cancelRoute")
        static let updateRoutingPreference = Notification.Name(rawValue: "updateRoutingPreference")
        static let filterTrails = Notification.Name(rawValue: "filterTrails")
    }
}
