//
//  DownloadError.swift
//  Snowport
//
//  Created by Peyton McKee on 12/29/23.
//

import Foundation

enum DownloadError: Error {
    case failedToConvertDataToImage
}

extension DownloadError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedToConvertDataToImage:
            return "Could not convert data to image, reload the app or contact developer."
        }
    }
}
