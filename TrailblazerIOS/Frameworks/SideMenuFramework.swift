//
//  SideMenuFramework.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/21/22.
//

import Foundation
import UIKit

class SideMenuFramework
{
    unowned let viewController: UIViewController
    let window : UIView
    let width : CGFloat
    weak var view :  UIView?
    
    init(vc : UIViewController) {
        self.viewController = vc
        self.window = vc.view
        self.width = vc.view.bounds.width
    }
    
    func presentItems()
    {
        guard let view = view else{ return }
        window.addSubview(view)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            view.frame = CGRect(x: 0, y: 80, width: self.width, height: self.window.bounds.height)
        }, completion: nil)
    }
    
    func presentDroppedDownItems()
    {
        guard let view = view else{ return }
        window.addSubview(view)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            view.frame = CGRect(x: 0, y: 120, width: self.width, height: self.window.bounds.height)
        }, completion: nil)
    }
    
    func dismissItems()
    {
        guard let view = view else { return }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            view.frame = CGRect(x: 0 - self.width, y: 80, width: self.width, height: self.window.bounds.height)
        }, completion: nil)
    }
    
    deinit {
        print("Deallocating Side menu framework")
    }
}

