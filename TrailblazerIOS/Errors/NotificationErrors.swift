//
//  NotificationErrors.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/18/23.
//

import Foundation

enum NotificationErrors : Error {
    case routingPreferenceSentIncorrectlyError
}

extension NotificationErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .routingPreferenceSentIncorrectlyError:
            return "Routing Preference Sent Incorrectly"
        }
    }
}
