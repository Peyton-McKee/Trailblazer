//
//  MapDelegate.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit
import MapKit

extension InteractiveMapViewController: MKMapViewDelegate
{
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        if overlay.isKind(of: CustomPolyline.self)
        {
            let polyLine = overlay as! CustomPolyline
            let polylineRenderer = MKPolylineRenderer(overlay: polyLine)
            polylineRenderer.strokeColor = polyLine.color!
            polylineRenderer.lineWidth = 3.0
            
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if(view.annotation?.title! == nil)
        {
            self.cancelTrailReportView.isHidden = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if !(self.cancelTrailReportView.isHidden)
        {
            self.selectedTrailReport = nil
            self.selectedTrailReportAnnotation = nil
            self.cancelTrailReportView.isHidden = true
        }
        
        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2.0, longitudeDelta: currentSpan.longitudeDelta / 2.0)
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
        guard let annotation = view.annotation as? ImageAnnotation else {
            return
        }
        if let status = annotation.status
        {
            print(status)
        }
        if view.annotation is MKUserLocation
        {
            return
            //then you selected the user location
        }
        if (view.annotation?.title! == nil)
        {
            self.selectedTrailReport = MapInterpreter.shared.trailReports.first(where: {$0.id == annotation.id})
            self.selectedTrailReportAnnotation = annotation
            self.cancelTrailReportView.isHidden = false
            return
        }
        if self.routeInProgress
        {
            //then there is already a route in progress and they must cancel the route before selecting another destination
            return
        }
        self.sampleRoute(origin: nil, destination: view.annotation as! ImageAnnotation)
    }
}
