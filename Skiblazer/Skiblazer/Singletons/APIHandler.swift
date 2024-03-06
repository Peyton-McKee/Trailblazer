//
//  APIHandler.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Amplify
import SwiftUI

class APIHandler {
    static var maximumFileSize = 1000000

    static func getAllMaps() async throws -> [Map] {
        let result = try await Amplify.API.query(request: .list(Map.self))
        let maps = try result.get()
        return maps.elements
    }

    static func getMapInfo(_ map: Map) async throws -> MapInfo {
        var taskMap = [StorageExtension: StorageDownloadDataTask]()

        StorageExtension.allCases.forEach { ex in
            taskMap.updateValue(Amplify.Storage.downloadData(key: map.storageKeyPrefix + ex.rawValue), forKey: ex)
        }

        let data = try await withThrowingTaskGroup(of: (key: String, value: GeoJSON).self, returning: [String: GeoJSON].self) { group in
            for (key, task) in taskMap {
                group.addTask {
                    let data = try await task.value
                    let geoJson = try JSONDecoder().decode(GeoJSON.self, from: data)
                    return (key.rawValue, geoJson)
                }
            }

            return try await group.reduce(into: [String: GeoJSON]()) { partialResult, keyValue in
                partialResult.updateValue(keyValue.value, forKey: keyValue.key)
            }
        }

        let imageTask = Amplify.Storage.downloadData(key: map.storageKeyPrefix + "image")
        let imageData = try await imageTask.value

        guard let easyTrails = data[StorageExtension.easy.rawValue],
              let intermediateTrails = data[StorageExtension.intermediate.rawValue],
              let advancedTrails = data[StorageExtension.advanced.rawValue],
              let expertsOnlyTrails = data[StorageExtension.expertsOnly.rawValue],
              let terrainParks = data[StorageExtension.terrainPark.rawValue],
              let lifts = data[StorageExtension.lift.rawValue],
              let connectors = data[StorageExtension.connector.rawValue], let image = UIImage(data: imageData)
        else {
            throw APIError.invalidConfiguration("Map does not contain necessary files to complete download", "Make sure your map has an image and easy, intermediate, advanced, experts only, connector trails as well as lifts and terrain parks", nil)
        }

        return .init(easyTrails: easyTrails, intermediateTrails: intermediateTrails, advancedTrails: advancedTrails, expertsOnlyTrails: expertsOnlyTrails, lifts: lifts, connectors: connectors, terrainParks: terrainParks, map: map)
    }

    static func uploadDocument(_ documentUrl: URL, _ key: String) async throws {
        guard documentUrl.startAccessingSecurityScopedResource() else {
            throw InternalError.failedToAccessFileURL
        }

        let data = try Data(contentsOf: documentUrl)
        let uploadProgress = Amplify.Storage.uploadData(key: key, data: data)
        _ = try await uploadProgress.value
    }

    static func downloadImage(_ key: String) async throws -> UIImage {
        let task = Amplify.Storage.downloadData(key: key)
        let imageData = try await task.value

        guard let image = UIImage(data: imageData) else {
            throw DownloadError.failedToConvertDataToImage
        }

        return image
    }

    static func uploadMap(_ name: String, _ image: Data, _ urls: [(StorageExtension, URL)], mountainReportUrl: String, trailStatusElementId: String, liftStatusElementId: String) async throws {
        try await Self.uploadImageData(name + "-image", image)
        try await withThrowingTaskGroup(of: Void.self) { group in
            for (key, url) in urls {
                group.addTask {
                    try await Self.uploadDocument(url, name + "-" + key.rawValue)
                }
            }

            try await group.reduce(into: ()) { _, _ in }
        }

        let mountainUrl = mountainReportUrl.isEmpty ? nil : mountainReportUrl
        let trailStatus = trailStatusElementId.isEmpty ? nil : trailStatusElementId
        let liftStatus = liftStatusElementId.isEmpty ? nil : liftStatusElementId

        let map = Map(name: name, storageKeyPrefix: name + "-", mountainReportUrl: mountainUrl, trailStatusElementId: trailStatus, liftStatusElementId: liftStatus)
        let task = try await Amplify.API.mutate(request: .create(map))
        _ = try task.get()
    }

    static func uploadImageData(_ key: String, _ data: Data) async throws {
        guard data.count < Self.maximumFileSize else {
            throw UploadError.fileToLarge
        }

        let task = Amplify.Storage.uploadData(key: key, data: data)
        _ = try await task.value
    }
}
