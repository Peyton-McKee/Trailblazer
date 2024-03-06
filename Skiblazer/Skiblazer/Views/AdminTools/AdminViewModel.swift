//
//  AdminViewModel.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import SwiftUI

struct AdminProps {}

class AdminViewModel: LoadableObject {
    @Published var state: LoadingState<AdminProps> = .loaded(.init())

    @Published var easyTrailsJsonUrl: URL?
    @Published var intermediateTrailsJsonUrl: URL?
    @Published var advancedTrailsJsonUrl: URL?
    @Published var expertTrailsJsonUrl: URL?
    @Published var terrainParksJsonUrl: URL?
    @Published var connectorsJsonUrl: URL?
    @Published var liftsJsonUrl: URL?

    @Published var mapName: String = ""
    @Published var mountainReportUrl: String = ""
    @Published var trailStatusElementId: String = ""
    @Published var liftStatusElementId: String = ""

    @Published var photoData: Data?
    @Published var toast: Toast?

    func load() {}

    func saveMap() {
        self.state = .loading
        guard let easyTrailsJsonUrl = self.easyTrailsJsonUrl,
              let intermediateTrailsJsonUrl = self.intermediateTrailsJsonUrl,
              let advancedTrailsJsonUrl = self.advancedTrailsJsonUrl,
              let expertTrailsJsonUrl = self.expertTrailsJsonUrl,
              let terrainParksJsonUrl = self.terrainParksJsonUrl,
              let connectorsJsonUrl = self.connectorsJsonUrl,
              let liftsJsonUrl = self.liftsJsonUrl
        else {
            self.fail(FormError.requiredItemNotFilledOut(item: "Missing URL"), .init())
            return
        }

        guard let photoData = self.photoData else {
            self.fail(FormError.requiredItemNotFilledOut(item: "Missing Photo"), .init())
            return
        }

        guard !self.mapName.isEmpty else {
            self.fail(FormError.requiredItemNotFilledOut(item: "Map Name"), .init())
            return
        }

        self.transitionState(.loading)

        let urls = [(StorageExtension.easy, easyTrailsJsonUrl), (StorageExtension.intermediate, intermediateTrailsJsonUrl), (StorageExtension.advanced, advancedTrailsJsonUrl), (StorageExtension.expertsOnly, expertTrailsJsonUrl), (StorageExtension.terrainPark, terrainParksJsonUrl), (StorageExtension.connector, connectorsJsonUrl), (StorageExtension.lift, liftsJsonUrl)]
        Task {
            do {
                try await APIHandler.uploadMap(self.mapName, photoData, urls, mountainReportUrl: self.mountainReportUrl, trailStatusElementId: self.trailStatusElementId, liftStatusElementId: self.liftStatusElementId)
                DispatchQueue.main.async {
                    self.toast = Toast(style: .success, message: "Successfully Uploaded Map")

                    self.load(.init())
                }
            } catch {
                self.fail(error, .init())
            }
        }
    }

    func selectPhoto(_ result: Result<Data?, Error>) {
        switch result {
        case .success(let data):
            self.photoData = data
        case .failure(let error):
            self.fail(error, .init())
        }
    }
}
