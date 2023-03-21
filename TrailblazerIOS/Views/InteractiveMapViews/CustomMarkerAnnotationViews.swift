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
            switch annotation.difficulty {
            case .easy:
                markerTintColor = .Theme.easyColor
                glyphImage = .init(systemName: "figure.skiing.downhill")
            case .intermediate:
                markerTintColor = .Theme.intermediateColor
                glyphImage = .init(systemName: "figure.skiing.downhill")
            case .advanced:
                markerTintColor = .Theme.advancedColor
                glyphImage = .init(systemName: "figure.skiing.downhill")
            case .expertsOnly:
                markerTintColor = .Theme.expertsOnlyColor
                glyphImage = .init(systemName: "figure.skiing.downhill")
            case .lift:
                glyphImage = .init(systemName: "arrow.up")
                markerTintColor = .Theme.liftsColor
            case .terrainPark:
                markerTintColor = .Theme.terrainParksColor
                glyphImage = .init(systemName: "figure.skiing.downhill")
            case .none:
                markerTintColor = .Theme.easyColor
                glyphImage = .init(systemName: "figure.skiing.downhill")
            }
            clusteringIdentifier = "cluster"
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
