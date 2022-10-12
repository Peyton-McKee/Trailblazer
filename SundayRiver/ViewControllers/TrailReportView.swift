//
//  TrailReportViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/11/22.
//

import Foundation
import UIKit

class TrailReportView : UIView {
    var mogulButton : UIButton?
    var iceButton : UIButton?
    var crowdedButton : UIButton?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView()
    {
        mogulButton = UIButton()
        mogulButton?.translatesAutoresizingMaskIntoConstraints = false
        mogulButton?.setTitle("Moguls", for: .normal)
        mogulButton?.backgroundColor = .blue
        
        iceButton = UIButton()
        iceButton?.translatesAutoresizingMaskIntoConstraints = false
        iceButton?.setTitle("Ice", for: .normal)
        iceButton?.backgroundColor = .lightGray
        
        crowdedButton = UIButton()
        crowdedButton?.translatesAutoresizingMaskIntoConstraints = false
        crowdedButton?.setTitle("Crowded", for: .normal)
        crowdedButton?.setTitleColor(.white, for: .normal)
        crowdedButton?.backgroundColor = .black
        
        addSubview(mogulButton!)
        addSubview(iceButton!)
        addSubview(crowdedButton!)
    }
    func organizeButtons()
    {
        createConstraints(item: mogulButton!, distFromLeft: 0, distFromTop: 0)
        createConstraints(item: iceButton!, distFromLeft: 0, distFromTop: Double(layoutMarginsGuide.layoutFrame.height) / 2)
        createConstraints(item: crowdedButton!, distFromLeft: 0, distFromTop: Double(layoutMarginsGuide.layoutFrame.height))
    }
    private func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            ])
    }
    
}
