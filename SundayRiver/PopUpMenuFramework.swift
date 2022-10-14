//
//  RouteOverviewMenu.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/13/22.
//

import Foundation
import UIKit

class PopUpMenuFramework
{
    var viewController: UIViewController
    var transparentView : UIView
    var view :  UIView?
    var window : UIWindow
    var height : CGFloat
    var screenSize: CGSize
    init(viewController : UIViewController, window: UIWindow, screenSize : CGSize, transparentView: UIView, height: CGFloat) {
        self.viewController = viewController
        self.window = window
        self.screenSize = screenSize
        self.transparentView = transparentView
        self.height = height
    }
    
    func presentItems()
    {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        guard let view = view else{ return }
        window.addSubview(transparentView)
        window.addSubview(view)
        transparentView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            view.frame = CGRect(x: 0, y: self.screenSize.height - self.height, width: self.screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    func dismissItems()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.view!.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.height)
        }, completion: nil)
    }
}

