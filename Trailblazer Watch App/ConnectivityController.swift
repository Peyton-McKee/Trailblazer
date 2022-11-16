//
//  ConnectivityController.swift
//  Trailblazer Watch App
//
//  Created by Peyton McKee on 11/14/22.
//

import Foundation
import Combine

enum ConnectivityTypes: String
{
    case route = "route"
}
struct Route: Identifiable{
    var id: Int
    var annotationName: String
    var coordinates: [Double]
}

final class ConnectivityController: NSObject, ObservableObject {
    static let shared = ConnectivityController()
    
    @Published var route : [Route] = []
    
    private var cancellable: Set<AnyCancellable> = []

    override private init() {
        super.init()
        Connectivity.shared.$routeIds
            .dropFirst()
            .map{ ids in self.route.filter { ids.contains($0.id) } }
            .receive(on: DispatchQueue.main)
            .assign(to: \.route, on: self)
            .store(in: &cancellable)
    }
    
    private func updateCompanion() {
        let ids = route.map { $0.id }
        Connectivity.shared.send(routeIds: ids)
    }
    
    public func setRoute(route: [Route])
    {
        self.route = route
        updateCompanion()
    }
}
