//
//  DirectionsView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 4/7/23.
//

import Foundation
import UIKit
import CoreLocation

enum Orientation: String {
    case left = "left"
    case right = "right"
    case straight = "straight"
}
final class DirectionsView : UIView {
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .Theme.markerFelt
        return label
    }()
    
    let trailLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .Theme.markerFelt
        return label
    }()
    
    lazy var turnIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.turnImage
        imageView.tintColor = .systemBlue
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        return imageView
    }()
    
    lazy var HStack : UIStackView = {
        let stackView = UIStackView(frame: CGRect(x: 10, y: 30, width: self.frame.width - 20, height: self.frame.height - 40))
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        [turnIcon.self, VStack.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    lazy var VStack : UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        [distanceLabel.self, trailLabel.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    let turnImage = UIImage(systemName: "arrow.triangle.turn.up.right.diamond.fill")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .init(hex: "#000000ff")
        self.addSubview(self.HStack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func displayUpcomingDirectionFor(route: [Vertex<ImageAnnotation>]) {
        guard let first = route.first(where: {$0.value.title != "Your Location"}) else {
            return
        }
        
        let firstPoint = CLLocation(latitude: first.value.coordinate.latitude, longitude: first.value.coordinate.longitude)

        guard let upcomingKeyAnnotation = route.first(where: { $0.value.title != first.value.title && $0.value.title != "Your Location"}) else {
            self.turnIcon.image = UIImage(systemName: "flag.checkered")!
            if let destination = route.last {
                let destinationPoint = CLLocation(latitude: destination.value.coordinate.latitude, longitude: destination.value.coordinate.longitude)
                let distanceToFinish = firstPoint.distance(from: destinationPoint)
                self.distanceLabel.text = "\(String(format:"%.0f", distanceToFinish * 3.28084)) feet"
                self.trailLabel.text = destination.value.title
            }
            return
        }
        
        guard let lastIndex = route.firstIndex(of: upcomingKeyAnnotation) else {
            return
        }
        
        let last = route[lastIndex - 2]
        
        let upcomingPoint = CLLocation(latitude: upcomingKeyAnnotation.value.coordinate.latitude, longitude: upcomingKeyAnnotation.value.coordinate.longitude)
        let lastPoint = CLLocation(latitude: last.value.coordinate.latitude, longitude: last.value.coordinate.longitude)
        
        let distanceToUpcomingKeyAnnotation = upcomingPoint.distance(from: firstPoint)
        let orientation = orientation(p1: firstPoint, p2: lastPoint, p3: upcomingPoint)
        self.distanceLabel.text = "\(String(format:"%.0f", distanceToUpcomingKeyAnnotation * 3.28084)) feet"
        self.trailLabel.text = upcomingKeyAnnotation.value.title!
        switch orientation {
        case .left:
            self.turnIcon.image = UIImage(cgImage: turnImage.cgImage!, scale: turnImage.scale, orientation: .upMirrored).withTintColor(.systemBlue)
        case .right:
            self.turnIcon.image = self.turnImage
        case .straight:
            self.turnIcon.image = .init(systemName: "arrow.triangle.merge")!
        }
    }
    
    // Function to determine the orientation of three points
    func orientation(p1: CLLocation, p2: CLLocation, p3: CLLocation) -> Orientation {
        let val = (p2.coordinate.longitude - p1.coordinate.longitude) * (p3.coordinate.latitude - p2.coordinate.latitude) - (p2.coordinate.latitude - p1.coordinate.latitude) * (p3.coordinate.longitude - p2.coordinate.longitude)
        if val == 0 {
            return .straight // Points are collinear
        } else if val > 0 {
            return .right // Clockwise orientation
        } else {
            return .left// Counterclockwise orientation
        }
    }
}
