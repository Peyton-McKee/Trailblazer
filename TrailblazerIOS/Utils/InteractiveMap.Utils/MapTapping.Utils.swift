//
//  MapTapping.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/10/23.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

extension InteractiveMapViewController {
    @objc func mapTapped(_ tap: UITapGestureRecognizer) {
        if tap.state == .recognized {
            // Get map coordinate from touch point
            let touchPt: CGPoint = tap.location(in: self.interactiveMapView)
            let coord: CLLocationCoordinate2D = self.interactiveMapView.convert(touchPt, toCoordinateFrom: self.interactiveMapView)
            let maxMeters: Double = meters(fromPixel: 22, at: touchPt)
            var nearestDistance: Float = MAXFLOAT
            var nearestPoly: CustomPolyline? = nil
            // for every overlay ...
            for overlay: MKOverlay in self.interactiveMapView.overlays {
                // .. if MKPolyline ...
                if (overlay is MKPolyline) {
                    // ... get the distance ...
                    let distance: Float = Float(distanceOf(pt: MKMapPoint(coord), toPoly: overlay as! MKPolyline))
                    // ... and find the nearest one
                    if distance < nearestDistance {
                        nearestDistance = distance
                        nearestPoly = overlay as? CustomPolyline
                    }
                    
                }
            }
            if Double(nearestDistance) <= maxMeters {
                if nearestPoly != nil
                {
                    var closestVertex = self.selectedGraph.vertices[0]
                    
                    for vertex in self.selectedGraph.vertices
                    {
                        if(sqrt(pow(vertex.value.coordinate.latitude - coord.latitude, 2) + pow(vertex.value.coordinate.longitude - coord.longitude, 2)) < (sqrt(pow(closestVertex.value.coordinate.latitude - coord.latitude, 2) + (pow(closestVertex.value.coordinate.longitude - coord.longitude, 2))))){
                            closestVertex = vertex
                        }
                    }
                    self.sampleRoute(origin: nil, destination: closestVertex.value)
                }
            }
        }
    }
    
    private func distanceOf(pt: MKMapPoint, toPoly poly: MKPolyline) -> Double {
        var distance: Double = Double(MAXFLOAT)
        for n in 0..<poly.pointCount - 1 {
            let ptA = poly.points()[n]
            let ptB = poly.points()[n + 1]
            let xDelta: Double = ptB.x - ptA.x
            let yDelta: Double = ptB.y - ptA.y
            if xDelta == 0.0 && yDelta == 0.0 {
                // Points must not be equal
                continue
            }
            let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var ptClosest: MKMapPoint
            if u < 0.0 {
                ptClosest = ptA
            }
            else if u > 1.0 {
                ptClosest = ptB
            }
            else {
                ptClosest = MKMapPoint(x: ptA.x + u * xDelta, y: ptA.y + u * yDelta)
            }
            
            distance = min(distance, ptClosest.distance(to: pt))
        }
        return distance
    }
    
    private func meters(fromPixel px: Int, at pt: CGPoint) -> Double {
        let ptB = CGPoint(x: pt.x + CGFloat(px), y: pt.y)
        let coordA: CLLocationCoordinate2D = self.interactiveMapView.convert(pt, toCoordinateFrom: self.interactiveMapView)
        let coordB: CLLocationCoordinate2D = self.interactiveMapView.convert(ptB, toCoordinateFrom: self.interactiveMapView)
        return MKMapPoint(coordA).distance(to: MKMapPoint(coordB))
    }
}
