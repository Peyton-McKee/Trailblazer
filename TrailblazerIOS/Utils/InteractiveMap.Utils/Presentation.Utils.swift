//
//  Presentation.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController {
    @objc func presentSideMenu()
    {
        if searchBar.isDroppedDown
        {
            self.trailSelectorView.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu.presentDroppedDownItems()
        }
        else
        {
            self.trailSelectorView.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu.presentItems()
        }
        trailSelectorView.isPresented = true
    }
    
    /// presentTrailReportMenu: void -> void
    /// Presents the Trail Report Menu
    func presentTrailReportMenu()
    {
        self.trailReportTableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 250)
        self.trailReportMenu.presentItems()
    }
}
