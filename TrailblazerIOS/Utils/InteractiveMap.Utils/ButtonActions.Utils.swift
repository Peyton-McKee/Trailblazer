//
//  ButtonActions.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit
import MapKit

extension InteractiveMapViewController {
    /// letsGoButtonPressed: void -> void
    /// dismisses the route overview menu
    @objc func letsGoButtonPressed()
    {
        self.routeOverviewMenu.dismissItems()
        self.cancelButton.isHidden = false
        
        self.recenter()
        
        guard (Self.currentUser.id) != nil else{return}
        self.timer = Date.now
    }
    
    @objc func recenter()
    {
        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let myLocation = CLLocationCoordinate2D(latitude: locationManager.locationManager.location!.coordinate.latitude, longitude: locationManager.locationManager.location!.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: span)
        myMap.setRegion(region, animated: false)
        let mapCamera = MKMapCamera(lookingAtCenter: myLocation, fromDistance: 1000, pitch: 60, heading: 50)
        myMap.setCamera(mapCamera, animated: false)
        
        myMap.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func cancelRoute()
    {
        print("cancelling route")
        self.initialLocation = nil
        self.routeInProgress = false
        self.pathCreated = []
        self.trailSelectorView.isPresented = false
        self.cancelButton.isHidden = true
        while self.selectedGraph.vertices.last?.value.title! == "Your Location"{
            print("test")
            self.selectedGraph.removeLastVertex()
        }
        connectivityController.setRoute(route: [])
        showAllTrails()
    }
    
    @objc func toggleGraph()
    {
        if self.routeInProgress
        {
            self.cancelRoute()
        }
        if self.isRealTimeGraph {
            self.selectedGraph = self.preferredRoutingGraph
        }
        else
        {
            self.selectedGraph = WebAnalysis.shared.realTimeGraph
        }
        self.trailSelectorView.reloadMyTrails()
        self.isRealTimeGraph.toggle()
        self.showAllTrails()
    }
}
