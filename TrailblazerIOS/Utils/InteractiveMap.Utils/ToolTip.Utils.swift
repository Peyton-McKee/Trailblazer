//
//  ToolTip.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController {
    
    @objc func showToolTip(sender: UIButton) {
        let p = sender.center
        let tipWidth: CGFloat = 80
        let tipHeight: CGFloat = 40
        let tipX = p.x - tipWidth / 2
        let tipY: CGFloat = p.y - tipHeight
        var text = ""
        switch sender{
        case toggleGraphButton:
            switch isRealTimeGraph{
            case true:
                text = "View All Trails"
            case false:
                text = "View Open Trails"
            }
        default:
            text = "Recenter"
        }
        let tipView = ToolTipView(frame: CGRect(x: tipX, y: tipY, width: tipWidth, height: tipHeight), text: text, tipPos: .right)
        view.addSubview(tipView)
        performShow(tipView)
    }
    
    func performShow(_ v: UIView?) {
        v?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
            v?.transform = .identity
        }) { finished in
            if finished
            {
                UIView.animate(withDuration: 0.3, delay: 3, options: .curveEaseOut, animations: {
                    v?.transform = .init(scaleX: 0.01, y: 0.01)
                })
            }
        }
    }
    
}
