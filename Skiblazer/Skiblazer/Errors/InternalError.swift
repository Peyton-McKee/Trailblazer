//
//  InternalError.swift
//  Snowport
//
//  Created by Peyton McKee on 1/4/24.
//

import Foundation

enum InternalError : Error {
    case vendorNotSelected
    case menuContentInitializedIncorrectly
    case imagesNotDownloadedProperly
    case failedToAccessFileURL
    case podIdDoesNotRelateToVendor
    case couldNotConstructValidURL
}

extension InternalError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .vendorNotSelected:
            return "No Vendor Selected, this is an internal error, please contact developer."
        case .menuContentInitializedIncorrectly:
            return "Menu Content requires an image or image key, this is an internal error, please contact developer."
        case .imagesNotDownloadedProperly:
            return "Images not downloaded properly, this is an internal error, please contact developer."
        case .failedToAccessFileURL:
            return "Unable to access file, please give appropriate permissions to access file."
        case .podIdDoesNotRelateToVendor:
            return "No vendor found for this pod."
        case .couldNotConstructValidURL:
            return "Could not construct a valid URL for Network Request"
        }
    }
}
