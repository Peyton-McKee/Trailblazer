//
//  RouteOverviewView.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/13/22.
//

import Foundation
import UIKit


class RouteOverviewView : UIView {
    let tripLbl : UILabel = {
        let tripLbl = UILabel()
        tripLbl.translatesAutoresizingMaskIntoConstraints = false
        tripLbl.textAlignment = .center
        tripLbl.layer.cornerRadius = 10
        tripLbl.textColor = .black
        return tripLbl
    }()
    
    let directionsLabel : UILabel = {
        let directionsLabel = UILabel()
        directionsLabel.translatesAutoresizingMaskIntoConstraints = false
        directionsLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 15)
        directionsLabel.textColor = .black
        return directionsLabel
    }()
    
    let letsGoButton : UIButton = {
        let letsGoButton = UIButton()
        letsGoButton.translatesAutoresizingMaskIntoConstraints = false
        letsGoButton.backgroundColor = .blue
        letsGoButton.setTitle("Let's Go!", for: .normal)
        letsGoButton.layer.cornerRadius = 15
        return letsGoButton
    }()
    
    let trailReportLabel : UILabel = {
        let trailReportLabel = UILabel()
        trailReportLabel.translatesAutoresizingMaskIntoConstraints = false
        trailReportLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 10)
        trailReportLabel.textColor = .black
        return trailReportLabel
    }()
    
    let viewFullDirectionsButton : UIButton = {
        let viewFullDirectionsButton = UIButton()
        viewFullDirectionsButton.translatesAutoresizingMaskIntoConstraints = false
        viewFullDirectionsButton.setTitle("View Full Directions...", for: .normal)
        viewFullDirectionsButton.setTitleColor(.black, for: .normal)
        viewFullDirectionsButton.contentHorizontalAlignment = .left
        viewFullDirectionsButton.contentVerticalAlignment = .top
        viewFullDirectionsButton.titleLabel!.font = UIFont(name: "EuphemiaUCAS-bold", size: 10)
        viewFullDirectionsButton.layer.cornerRadius = 10
        return viewFullDirectionsButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureOverview(trip: String, trailReports: String, totalDirections: String, count: Int) {
        var directions = totalDirections
        if directions.isEmpty
        {
            self.directionsLabel.text = "Could not find Route"
            self.viewFullDirectionsButton.isHidden = true
        }
        else if count <= 2
        {
            let index = directions.index(directions.startIndex, offsetBy: directions.count - 2)
            directions = String(directions.prefix(upTo: index))
            self.directionsLabel.text = "\(directions)"
            self.viewFullDirectionsButton.isHidden = true
        }
        else
        {
            var searchRange = directions.startIndex..<directions.endIndex
            var indices: [String.Index] = []
            while let range = directions.range(of: ";", options: .caseInsensitive, range: searchRange)
            {
                searchRange = range.upperBound..<searchRange.upperBound
                indices.append(range.lowerBound)
            }
            self.directionsLabel.text = "\(directions.prefix(upTo: indices[1]))"
            self.viewFullDirectionsButton.isHidden = false
        }
    }
}
