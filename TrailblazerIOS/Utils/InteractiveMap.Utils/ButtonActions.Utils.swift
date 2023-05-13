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
        self.directionsView.isHidden = false
        self.searchBar.isHidden = true
        self.reloadButtons()
        
        self.recenter()
        
        guard (Self.currentUser.id) != nil else{return}
        self.timer = Date.now
    }
    
    @objc func recenter()
    {
        self.interactiveMapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func cancelRoute()
    {
        print("cancelling route")
        self.routeInProgress = false
        self.pathCreated = []
        self.trailSelectorView.isPresented = false
        self.cancelButton.isHidden = true
        self.directionsView.isHidden = true
        self.searchBar.isHidden = false
        self.reloadButtons()
        self.connectivityController.setRoute(route: [])
        self.showAllTrails()
    }
    
    @objc func toggleGraph()
    {
        if self.routeInProgress
        {
            self.cancelRoute()
        }
        self.isRealTimeGraph.toggle()
        self.trailSelectorView.reloadMyTrails()
        self.showAllTrails()
    }
    
    @objc func presentFullDirections()
    {
        self.routeOverviewMenu.dismissItems()
        self.totalDirectionsView.isHidden = false
    }
    
    @objc func closeFullDirectionsAndPresentRouteOverview() {
        self.totalDirectionsView.isHidden = true
        self.routeOverviewMenu.presentItems()
    }
    
    @objc func closeFullDirections() {
        self.totalDirectionsView.isHidden = true
    }
    
    @objc func displayFullDirectionsView() {
        var directions : [DirectionsView] = []
        var tempPathToDest = self.pathCreated
        tempPathToDest.removeFirst()
        while !tempPathToDest.isEmpty {
            let newDirectionsView = DirectionsView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
            let currentTrailTitle = tempPathToDest[0].value.title
            guard let nextDirectionIndex = tempPathToDest.firstIndex(where: {$0.value.title != currentTrailTitle}) else { break }
            newDirectionsView.displayUpcomingDirectionFor(route: Array(tempPathToDest.prefix(through: nextDirectionIndex)))
            tempPathToDest = Array(tempPathToDest.suffix(from: nextDirectionIndex))
            directions.append(newDirectionsView)
        }
        
        self.totalDirectionsView.closeButton.removeTarget(self, action: #selector(self.closeFullDirectionsAndPresentRouteOverview), for: .touchUpInside)
        self.totalDirectionsView.closeButton.addTarget(self, action: #selector(self.closeFullDirections), for: .touchUpInside)
        self.totalDirectionsView.setDirections(directions: directions)
        self.totalDirectionsView.isHidden = false
    }
}
