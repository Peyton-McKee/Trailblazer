//
//  CustomMarkerAnnotationView.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/12/22.
//

import Foundation
import MapKit
import UIKit

class CustomAnnotationView: MKMarkerAnnotationView {
    let mogulGlyphImage: UIImage = {
        let rect = CGRect(origin: .zero, size: CGSize(width: 40, height: 40))
        return UIGraphicsImageRenderer(bounds: rect).image(actions: { _ in
            let radius: CGFloat = 12
            let offset: CGFloat = 30
            let insetY: CGFloat = 3
            let center = CGPoint(x: rect.midX, y: rect.maxY - radius - insetY)
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX - rect.midX/2, y: rect.maxY - radius - insetY))
            path.addCurve(to: CGPoint(x: rect.midX + rect.midX/2, y: rect.maxY - radius - insetY), controlPoint1: CGPoint(x: rect.midX, y: rect.maxY - offset), controlPoint2: CGPoint(x: rect.midX, y: rect.maxY - offset))
            path.close()
            UIColor.white.setFill()
            path.fill()
        })
    }()
    
    let icyGlyphImage: UIImage = {
        return .init(systemName: "snowflake")!
    }()
    
    let crowdedGlyphImage: UIImage = {
        return .init(systemName: "figure.walk")!
    }()
    
    override var annotation: MKAnnotation? {
        didSet { configure(for: annotation) }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        markerTintColor = .blue
        configure(for: annotation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for annotation: MKAnnotation?) {
        displayPriority = .defaultLow
        if(annotation?.subtitle == "Moguls")
        {
            glyphImage = self.mogulGlyphImage
            markerTintColor = .black
        }
        else if (annotation?.subtitle == "Crowded")
        {
            markerTintColor = .yellow
            glyphImage = self.crowdedGlyphImage
        }
        else if (annotation?.subtitle == "Icy"){
            glyphImage = self.icyGlyphImage
        }
        else
        {
            if let annotation = annotation as? ImageAnnotation{
                if(annotation.difficulty == .easy)
                {
                    markerTintColor = UIColor(red: 0.03, green: 0.25, blue: 0, alpha: 1)
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                else if(annotation.difficulty == .intermediate)
                {
                    markerTintColor = .blue
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                else if (annotation.difficulty == .lift)
                {
                    glyphImage = .init(systemName: "arrow.up")
                    markerTintColor = .purple
                }
                else if (annotation.difficulty == .expertsOnly)
                {
                    markerTintColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                else if (annotation.difficulty == .advanced)
                {
                    markerTintColor = .black
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                else
                {
                    markerTintColor = .orange
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                if(TrailsDatabase.jordanKeyAnnotations.contains(Vertex<ImageAnnotation>(annotation)))
                {
                    clusteringIdentifier = "Jordan"
                }
                else if(TrailsDatabase.auroraKeyAnnotations.contains(Vertex<ImageAnnotation>(annotation)))
                {
                    clusteringIdentifier = "Aurora"
                }
                else if(TrailsDatabase.northPeakKeyAnnotations.contains(Vertex<ImageAnnotation>(annotation)))
                {
                    clusteringIdentifier = "North Peak"
                }
                else if(TrailsDatabase.barkerKeyAnnotations.contains(Vertex<ImageAnnotation>(annotation)))
                {
                    clusteringIdentifier = "Barker"
                }
                else if(TrailsDatabase.southRidgeKeyAnnotations.contains(Vertex<ImageAnnotation>(annotation)))
                {
                    clusteringIdentifier = "Southridge"
                }
            }
        }
    }
}

class ClusterAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation?{
        didSet{
            displayPriority = .defaultHigh
        }
    }
}
