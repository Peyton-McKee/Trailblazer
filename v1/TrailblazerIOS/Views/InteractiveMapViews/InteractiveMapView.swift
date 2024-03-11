//
//  InteractiveMapViewController.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/21/23.
//

import Foundation
import UIKit
import MapKit

final class InteractiveMapView: MKMapView {
    
    weak var vc: InteractiveMapViewController?
    
    init(vc: InteractiveMapViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        self.mapType = MKMapType.satellite
        self.isRotateEnabled = true
        self.showsCompass = false
        self.setCamera(MKMapCamera(lookingAtCenter: self.centerCoordinate, fromDistance: CLLocationDistance(1200), pitch: 90, heading: CLLocationDirection(360)), animated: true)
        self.isZoomEnabled = true
        self.isScrollEnabled = true
        self.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 400,
            maxCenterCoordinateDistance: 12500)
        let selectTrailGesture = UITapGestureRecognizer(target: self.vc, action: #selector(self.vc?.mapTapped))
        let trailReportGesture = UILongPressGestureRecognizer(target: self.vc, action: #selector(self.vc?.addTrailReport))
        trailReportGesture.minimumPressDuration = 0.3
        self.addGestureRecognizer(trailReportGesture)
        self.addGestureRecognizer(selectTrailGesture)
        self.userTrackingMode = .followWithHeading
        self.showsUserLocation = true
        self.setUserTrackingMode(.followWithHeading, animated: true)
        self.delegate = self.vc
        self.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBoundaryAround(region: MKCoordinateRegion) {
        self.setRegion(region, animated: true)
        self.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
    }
    
}
