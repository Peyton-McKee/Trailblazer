//
//  ValidationUtils.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Foundation

class ValidationUtils {
    static func getMapBoxAccessToken() -> String {
        let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String
        return accessToken!
    }
}
