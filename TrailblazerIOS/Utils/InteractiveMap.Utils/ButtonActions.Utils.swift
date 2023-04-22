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
    
    @objc func closeFullDirections() {
        self.totalDirectionsView.isHidden = true
        self.routeOverviewMenu.presentItems()
    }
}
