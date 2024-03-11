//
//  RoutingError.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/11/24.
//

import Foundation

enum RoutingErrors: Error {
    case destinationNotFoundError
    case routeNotFoundError
    case originNotFoundError
}

extension RoutingErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .destinationNotFoundError:
            return "Could not find destination"
        case .routeNotFoundError:
            return "Could not find route to destination"
        case .originNotFoundError:
            return "Could not find origin to match selected trail"
        }
    }
}
