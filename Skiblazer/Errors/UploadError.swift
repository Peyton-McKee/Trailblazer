//
//  UploadError.swift
//  Snowport
//
//  Created by Peyton McKee on 1/9/24.
//

import Foundation

enum UploadError: Error {
    case fileToLarge
    case failedToConvertImageToData
}

extension UploadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileToLarge:
            return "File must be under 1 MB."
        case .failedToConvertImageToData:
            return "Unable to convert image to upload data."
        }
    }
}

