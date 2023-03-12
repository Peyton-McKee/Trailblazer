//
//  TrailSelector.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/10/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController {
    @objc func moveTrailSelectorView()
    {
        if(searchBar.isDroppedDown && trailSelectorView.isPresented)
        {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.trailSelectorView.frame = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: nil)
        }
        else if(trailSelectorView.isPresented)
        {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.trailSelectorView.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: nil)
        }
    }
}
