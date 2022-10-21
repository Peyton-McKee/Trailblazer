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
    var transparentView : UIView
    var view :  UIView?
    var window : UIWindow
    var width : CGFloat
    var screenSize: CGSize
    
    init(viewController : UIViewController, window: UIWindow, screenSize : CGSize, transparentView: UIView, width: CGFloat) {
        self.viewController = viewController
        self.window = window
        self.screenSize = screenSize
        self.transparentView = transparentView
        self.width = width
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
            view.frame = CGRect(x: 0, y: 0, width: self.width, height: self.screenSize.height)
        }, completion: nil)
    }
    
    func dismissItems()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.view!.frame = CGRect(x: 0 - self.width, y: 0, width: self.width, height: self.screenSize.height)
        }, completion: nil)
    }
}

