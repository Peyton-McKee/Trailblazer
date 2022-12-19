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
    let mogulGlyphImage: UIImage = .init(systemName: "exclamationmark.triangle.fill")!
    
    let icyGlyphImage: UIImage = .init(systemName: "snowflake")!
    
    let crowdedGlyphImage: UIImage = .init(systemName: "figure.walk")!
    
    let thinCoverGlyphImage : UIImage = .init(systemName: "leaf.fill")!
    
    let longLiftLineGlyphImage : UIImage = .init(systemName: "person.3.sequence.fill")!
    
    let snowmakingGlyphImage : UIImage = .init(systemName: "cloud.snow.fill")!
    
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
        guard let annotation = annotation as? ImageAnnotation else { return }
        
        if let subtitle = annotation.subtitle
        {
            switch subtitle{
            case TrailReportType.moguls.rawValue:
                markerTintColor = .black
                glyphImage = mogulGlyphImage
            case TrailReportType.ice.rawValue:
                markerTintColor = .blue
                glyphImage = icyGlyphImage
            case TrailReportType.crowded.rawValue:
                markerTintColor = .yellow
                glyphImage = crowdedGlyphImage
            case TrailReportType.thinCover.rawValue:
                markerTintColor = .brown
                glyphImage = thinCoverGlyphImage
            case TrailReportType.longLiftLine.rawValue:
                markerTintColor = .systemRed
                glyphImage = longLiftLineGlyphImage
            case TrailReportType.snowmaking.rawValue:
                markerTintColor = .white
                glyphImage = snowmakingGlyphImage
            default:
                break
            }
            clusteringIdentifier = "trailReport"
        }
        else
        {
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
                    markerTintColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
                }
                else if (annotation.difficulty == .expertsOnly)
                {
                    markerTintColor = .black
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                else if (annotation.difficulty == .advanced)
                {
                    markerTintColor = .gray
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
                else
                {
                    markerTintColor = .orange
                    glyphImage = .init(systemName: "figure.skiing.downhill")
                }
            clusteringIdentifier = "cluster"
        }
    }
    func checkClusteringIdentifier(trailList : [[Vertex<ImageAnnotation>]], identifier: String, annotation: ImageAnnotation) -> Bool
    {
        
        for trail in trailList
        {
            if trail.contains(Vertex<ImageAnnotation>(annotation))
            {
                clusteringIdentifier = identifier
                return true
            }
        }
        return false
    }
}

class ClusterAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation?{
        didSet{
            displayPriority = .defaultHigh
        }
    }
}
