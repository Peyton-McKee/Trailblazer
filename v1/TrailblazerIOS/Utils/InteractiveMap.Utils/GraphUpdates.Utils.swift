//
//  GraphUpdates.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController {
    func getPreferredGraph() -> EdgeWeightedDigraph<ImageAnnotation>
    {
        guard let defaultGraph = UserDefaults.standard.string(forKey: "routingPreference") else
        {
            return MapInterpreter.shared.difficultyGraph
        }
        switch defaultGraph{
        case RoutingType.leastDistance.rawValue:
            return MapInterpreter.shared.distanceGraph
        case RoutingType.quickest.rawValue:
            return MapInterpreter.shared.timeGraph
        default:
            return MapInterpreter.shared.difficultyGraph
        }
    }
    
    func updateSelectedGraphAndShowAllTrails()
    {
        self.showAllTrails()
    }
}
