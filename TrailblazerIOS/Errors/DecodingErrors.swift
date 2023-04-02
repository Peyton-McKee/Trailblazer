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
    case pointDecodingError
    case mapDecodingError
    case mapTrailDecdingError
    case mapConnectorDecodingError
}
extension DecodingErrors: LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .userDecodingError:
            return "Error Decoding User"
        case .userLocationDecodingError:
            return "Error Decoding User Locations"
        case .mapFileDecodingError:
            return "Error Decoding Map File"
        case .pointDecodingError:
            return "Error Decoding Point"
        case .mapDecodingError:
            return "Error Decoding Maps"
        case .mapTrailDecdingError:
            return "Error Decoding Map Trails"
        case .mapConnectorDecodingError:
            return "Error Decoding Map Connectors"
        }
    }
}
