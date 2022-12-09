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
    var viewController: UIViewController
    var view :  UIView?
    var window : UIView
    var width : CGFloat
    var screenSize: CGSize
    
    init(viewController : UIViewController, window: UIView, screenSize : CGSize, width: CGFloat) {
        self.viewController = viewController
        self.window = window
        self.screenSize = screenSize
        self.width = width
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
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.view!.frame = CGRect(x: 0 - self.width, y: 80, width: self.width, height: self.window.bounds.height)
        }, completion: nil)
    }
}

