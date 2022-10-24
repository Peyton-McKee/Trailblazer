//
//  UnusedFunctions.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/24/22.
//

import Foundation

//    private func configureKey()
//    {
//        let preferredFont = UIFont.systemFont(ofSize: 15)
//        easyLabel.text = "Easier Trails: 🟢"
//        easyLabel.textColor = .green
//        easyLabel.translatesAutoresizingMaskIntoConstraints = false
//        easyLabel.font = preferredFont
//
//        intermediateLabel.text = "Intermediate Trails: 🟦"
//        intermediateLabel.textColor = .blue
//        intermediateLabel.translatesAutoresizingMaskIntoConstraints = false
//        intermediateLabel.font = preferredFont
//
//        advancedLabel.text = "Advanced Trails: ♢"
//        advancedLabel.textColor = .black
//        advancedLabel.translatesAutoresizingMaskIntoConstraints = false
//        advancedLabel.font = preferredFont
//
//        expertsOnlyLabel.text = "Experts Only Trails: ♢♢"
//        expertsOnlyLabel.textColor = .red
//        expertsOnlyLabel.translatesAutoresizingMaskIntoConstraints = false
//        expertsOnlyLabel.font = preferredFont
//
//        liftLabel.text = "Lifts: -"
//        liftLabel.textColor = .purple
//        liftLabel.translatesAutoresizingMaskIntoConstraints = false
//        liftLabel.font = preferredFont
//
//
//        self.view.addSubview(easyLabel)
//        self.view.addSubview(intermediateLabel)
//        self.view.addSubview(advancedLabel)
//        self.view.addSubview(expertsOnlyLabel)
//        self.view.addSubview(liftLabel)
//
//        createConstraints(item: easyLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 20 )
//        createConstraints(item: intermediateLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 10  )
//        createConstraints(item: advancedLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) * 3 / 20)
//        createConstraints(item: expertsOnlyLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 5)
//        createConstraints(item: liftLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 4)
//    }
//
//
//    private func setupTileRenderer() {
//        let overlay = MapOverlay()
//        overlay.canReplaceMapContent = true
//        myMap.addOverlay(overlay, level: .aboveRoads)
//        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
//        overlay.minimumZ = 13
//        overlay.maximumZ = 17
//    }

//extension InteractiveMapViewController: CLLocationManagerDelegate
//{
    //    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
    //        myMap.camera.heading = newHeading.magneticHeading
    //        myMap.setCamera(myMap.camera, animated: true)
    //       }
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let location = locations[0]
    //        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
    //            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
    //            let region:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: span)
    //            myMap.setRegion(region, animated: true)
    //            self.myMap.showsUserLocation = true
    //
    //            let mapCamera = MKMapCamera(lookingAtCenter: myLocation, fromDistance: 5000, pitch: 30, heading: 0)
    //            myMap.setCamera(mapCamera, animated: true)
    //     }
    
//}
