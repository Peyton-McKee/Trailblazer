//
//  Dismissal.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController {
    @objc func dismissSideMenu()
    {
        if trailSelectorView.isPresented
        {
            self.trailSelectorMenu.dismissItems()
            self.trailSelectorView.isPresented = false
            self.searchBar.destinationTextField.text = nil
            self.searchBar.originTextField.text = nil
            self.wasCancelled = false
        }
    }
    
    /// dismissMenu: void -> void
    /// dismisses the Trail Report Menu
    @objc func dismissTrailReportMenu() {
        self.trailReportMenu.dismissItems()
    }
    
    /// dismissRouteOverviewMenu: void -> void
    /// dismisses the route overview menu and cancels any on going routes
    @objc func dismissRouteOverviewMenu()
    {
        self.cancelRoute()
        self.viewDidAppear(true)
        self.routeOverviewMenu.dismissItems()
    }
    
}
