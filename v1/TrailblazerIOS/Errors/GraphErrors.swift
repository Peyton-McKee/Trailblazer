//
//  GraphErrors.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/18/23.
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
