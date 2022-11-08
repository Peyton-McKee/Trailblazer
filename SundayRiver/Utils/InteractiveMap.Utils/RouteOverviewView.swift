//
//  RouteOverviewView.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/13/22.
//

import Foundation
import UIKit


class RouteOverviewView : UIView {
    var tripLbl = UILabel()
    var directionsLabel = UILabel()
    var letsGoButton = UIButton()
    var trailReportLabel = UILabel()
    var viewFullDirectionsButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureItems()
    {
        self.tripLbl.translatesAutoresizingMaskIntoConstraints = false
        self.tripLbl.textAlignment = .center
        self.tripLbl.layer.cornerRadius = 10
        self.tripLbl.textColor = .black
        self.directionsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.directionsLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 15)
        self.directionsLabel.textColor = .black
        
        self.trailReportLabel.translatesAutoresizingMaskIntoConstraints = false
        self.trailReportLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 10)
        self.trailReportLabel.textColor = .black
        
        self.letsGoButton.translatesAutoresizingMaskIntoConstraints = false
        self.letsGoButton.backgroundColor = .blue
        self.letsGoButton.setTitle("Let's Go!", for: .normal)
        self.letsGoButton.layer.cornerRadius = 15
        
        self.viewFullDirectionsButton.translatesAutoresizingMaskIntoConstraints = false
        self.viewFullDirectionsButton.setTitle("View Full Directions...", for: .normal)
        self.viewFullDirectionsButton.setTitleColor(.black, for: .normal)
        self.viewFullDirectionsButton.contentHorizontalAlignment = .left
        self.viewFullDirectionsButton.contentVerticalAlignment = .top
        self.viewFullDirectionsButton.titleLabel!.font = UIFont(name: "EuphemiaUCAS-bold", size: 10)
        self.viewFullDirectionsButton.layer.cornerRadius = 10
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 15
        
        self.addSubview(viewFullDirectionsButton)
        self.addSubview(tripLbl)
        self.addSubview(directionsLabel)
        self.addSubview(letsGoButton)
        self.addSubview(trailReportLabel)
        NSLayoutConstraint.activate([
            tripLbl.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            tripLbl.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            tripLbl.heightAnchor.constraint(equalToConstant: 40),
            tripLbl.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            directionsLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            directionsLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            directionsLabel.heightAnchor.constraint(equalToConstant: 20),
            directionsLabel.topAnchor.constraint(equalTo: self.tripLbl.bottomAnchor),
            viewFullDirectionsButton.topAnchor.constraint(equalTo: directionsLabel.bottomAnchor),
            viewFullDirectionsButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            viewFullDirectionsButton.widthAnchor.constraint(equalToConstant: self.bounds.width),
            viewFullDirectionsButton.heightAnchor.constraint(equalToConstant: 40),
            trailReportLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            trailReportLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            trailReportLabel.heightAnchor.constraint(equalToConstant: 50),
            trailReportLabel.topAnchor.constraint(equalTo: self.viewFullDirectionsButton.bottomAnchor),
            letsGoButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            letsGoButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            letsGoButton.heightAnchor.constraint(equalToConstant: 40),
            letsGoButton.topAnchor.constraint(equalTo: self.trailReportLabel.bottomAnchor)])
    }
}
