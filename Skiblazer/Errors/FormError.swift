//
//  FormError.swift
//  Snowport
//
//  Created by Peyton McKee on 12/27/23.
//

import Foundation

enum FormError: Error {
    case requiredItemNotFilledOut(item: String)
    case uniqueItemAlreadyExists(item: String, name: String)
    case incorrectFormat(item: String, requiredFormat: String)
    case custom(description: String)
}

extension FormError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .requiredItemNotFilledOut(let item):
            return "Please fill out \(item)"
        case .uniqueItemAlreadyExists(let item, let name):
            return "\(item) with name: \(name) already exists!"
        case .incorrectFormat(let item, let requiredFormat):
            return "\(item) must be a \(requiredFormat)"
        case .custom(let description):
            return description
        }
    }
}
