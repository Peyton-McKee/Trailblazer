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
struct Route: Identifiable {
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
    }
    
    private func updateCompanion() {
        let names = route.map { $0.annotationName }
        Connectivity.shared.send(routeName: names)
    }
    
    public func setRoute(route: [Route])
    {
        self.route = route
        updateCompanion()
    }
}
