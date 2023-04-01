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
        self.interactiveMapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func cancelRoute()
    {
        print("cancelling route")
        self.routeInProgress = false
        self.pathCreated = []
        self.trailSelectorView.isPresented = false
        self.cancelButton.isHidden = true
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
}
