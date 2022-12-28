//
//  DecodingErrors.swift
//  Trailblazer
//
//  Created by Peyton McKee on 12/14/22.
//

import Foundation

enum DecodingErrors: Error {
    case userDecodingError
    case userLocationDecodingError
    case mapFileDecodingError
}
extension DecodingErrors: CustomStringConvertible{
    public var description: String {
        switch self {
        case .userDecodingError:
            return "Error Decoding User"
        case .userLocationDecodingError:
            return "Error Decoding User Locations"
        case .mapFileDecodingError:
            return "Error Decoding Map File"
        }
    }
}
