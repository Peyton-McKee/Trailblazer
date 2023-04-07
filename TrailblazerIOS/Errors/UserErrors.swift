//
//  UserErrors.swift
//  Trailblazer
//
//  Created by Peyton McKee on 4/3/23.
//

import Foundation

enum UserErrors: Error {
    case userNotLoggedInError
    case userDoesNotHaveLocationServicesEnabledError
}

extension UserErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotLoggedInError:
            return "You must be logged in to use this feature!"
        case .userDoesNotHaveLocationServicesEnabledError:
            return "You do not have location services activated. Please activate to use this feature."
        }
    }
}
