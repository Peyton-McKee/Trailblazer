//
//  Configuration.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/10/23.
//

import Foundation
import UIKit
import MapKit

extension InteractiveMapViewController {
    func configureButtons()
    {
        configureIndividualButton(button: recenterButton, backgroundColor: .gray, image: UIImage(systemName: "location.circle")!)
        recenterButton.addTarget(self, action: #selector(recenter), for: .touchUpInside)
        recenterButton.addTarget(self, action: #selector(showToolTip), for: .touchDragExit)
        
        
        configureIndividualButton(button: cancelButton, backgroundColor: .cyan, image: UIImage(systemName: "xmark.circle.fill")!)
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(cancelRoute), for: .touchUpInside)
        
        configureIndividualButton(button: toggleGraphButton, backgroundColor: .lightText, image: UIImage(systemName: "perspective")!)
        toggleGraphButton.addTarget(self, action: #selector(toggleGraph), for: .touchUpInside)
        toggleGraphButton.addTarget(self, action: #selector(showToolTip), for: .touchDragExit)
        
        recenterButtonYConstraint = recenterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        cancelButtonYContraint = cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        
        cancelTrailReportView.isHidden = true
        cancelTrailReportView.configure()
        cancelTrailReportView.notThereUIButton.addTarget(self, action: #selector(removeTrailReport), for: .touchUpInside)
        view.addSubview(cancelTrailReportView)
        
        NSLayoutConstraint.activate([
            recenterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            recenterButtonYConstraint,
            recenterButton.heightAnchor.constraint(equalToConstant: 40),
            recenterButton.widthAnchor.constraint(equalToConstant: 40),
            cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20), cancelButtonYContraint,
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.widthAnchor.constraint(equalToConstant: 40),
            toggleGraphButton.leftAnchor.constraint(equalTo: recenterButton.leftAnchor),
            toggleGraphButton.topAnchor.constraint(equalTo: recenterButton.bottomAnchor),
            toggleGraphButton.heightAnchor.constraint(equalToConstant: 40),
            toggleGraphButton.widthAnchor.constraint(equalToConstant: 40),
            cancelTrailReportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelTrailReportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelTrailReportView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 150),
            cancelTrailReportView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 110)
        ])
    }
    
    func configureIndividualButton(button: UIButton, backgroundColor: UIColor, image: UIImage)
    {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        view.addSubview(button)
    }
}
