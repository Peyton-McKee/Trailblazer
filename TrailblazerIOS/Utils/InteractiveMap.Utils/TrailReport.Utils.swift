//
//  TrailReport.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit
import MapKit

extension InteractiveMapViewController {
    
    /// createTrailReport: TrailReportType -> void
    /// parameters:
    /// - type: The Trail Report Type for the Trail Report
    /// Creates a Trail Report of the specified type on the map and sends itself to the database
    func createTrailReport(type: TrailReportType)
    {
        self.dismissTrailReportMenu()
        let originAnnotation = createAnnotation(title: nil, latitude: self.trailReportAnnotation.coordinate.latitude, longitude: self.trailReportAnnotation.coordinate.longitude, difficulty: .easy)
        guard let closestTrail = try? getClosestAnnotation(origin: originAnnotation).value else { return }
        switch type
        {
        case .moguls:
            originAnnotation.subtitle = TrailReportType.moguls.rawValue
        case .ice:
            originAnnotation.subtitle = TrailReportType.ice.rawValue
        case .crowded:
            originAnnotation.subtitle = TrailReportType.crowded.rawValue
        case .thinCover:
            originAnnotation.subtitle = TrailReportType.thinCover.rawValue
        case .longLiftLine:
            originAnnotation.subtitle = TrailReportType.longLiftLine.rawValue
        case .snowmaking:
            originAnnotation.subtitle = TrailReportType.snowmaking.rawValue
        }
        guard let currentUserId = Self.currentUser.id else { return }
        APIHandler.shared.saveTrailReporrt(TrailReport(type: originAnnotation.subtitle!, latitude: originAnnotation.coordinate.latitude, longitude: originAnnotation.coordinate.longitude, dateMade: "\(Date.now)", trailMadeOn: closestTrail.title!, userID: "\(currentUserId)"))
        closestTrail.trailReport = originAnnotation
        self.myMap.addAnnotation(originAnnotation)
    }
    
    /// addTrailReport: Presents the trail report menu when the user holds down on a spot on the map
    ///
    /// paramaters:
    /// - gesture: The tap gesture that calls this function
    ///  When the user holds a point on the map, present the Trail Report Menu
    @objc func addTrailReport(gesture: UIGestureRecognizer) {
        
        if gesture.state == .ended {
            if let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                self.trailReportAnnotation = ImageAnnotation()
                self.trailReportAnnotation.coordinate = coordinate
                presentTrailReportMenu()
            }
        }
    }
    
    @objc func removeTrailReport(sender: UIButton)
    {
        let annotation = self.selectedGraph.vertices.first(where: {$0.value.trailReport == selectedTrailReportAnnotation})
        guard let selectedTrailReport = self.selectedTrailReport else {
            myMap.removeAnnotation(selectedTrailReportAnnotation!)
            annotation?.value.trailReport = nil
            selectedTrailReportAnnotation = nil
            //Then the trail report hasnt been stored on the database yet
            return
        }
        APIHandler.shared.deleteTrailReport(id: selectedTrailReport.id)
        self.selectedTrailReport = nil
        myMap.removeAnnotation(selectedTrailReportAnnotation!)
        annotation?.value.trailReport = nil
        selectedTrailReportAnnotation = nil
    }
    
    func displayCurrentTrailReports(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        myMap.addAnnotations(graph.vertices.map({ $0.value }).filter({ $0.trailReport != nil }).map({ $0.trailReport! }))
    }
    
}
