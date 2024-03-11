//
//  GraphError.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/11/24.
//

import Foundation

enum GraphErrors: Error {
    case selectedGraphHasNoVerticesError
}

extension GraphErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .selectedGraphHasNoVerticesError:
            return "Error: Map was not properly loaded."
        }
    }
}
