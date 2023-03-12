//
//  LocationManager.swift
//  SundayRiver
//
//  Created by Peyton McKee on 11/8/22.
//

import Foundation
import CoreLocation

extension InteractiveMapViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.routeInProgress && self.canFindPathAgain && self.pathCreated[0].value.title == "Your Location"
        {
            self.canFindPathAgain = false
            //the last element of path created is our destination
            self.displayRoute(origin: nil, destination: self.pathCreated[self.pathCreated.count - 1].value)
        }
        
        guard let currentUserId = Self.currentUser.id else
        {
            return
        }
        let radius = 30.0
        let userLocation = locations[0]
        var liftWaiting : Vertex<ImageAnnotation>?
        var timeBegan : Date?
        if !isWaitingInLine{
            for vertex in self.baseLiftVertexes{
                let liftLocation = CLLocation(latitude: vertex.value.coordinate.latitude, longitude: vertex.value.coordinate.longitude)
                if userLocation.distance(from: liftLocation) <= radius
                {
                    isWaitingInLine = true
                    liftWaiting = vertex
                    timeBegan = Date.now
                    print("isWaiting in line for lift \(liftWaiting?.value.title)")
                    break
                }
            }
        }
        else {
            guard let lift = liftWaiting, let startTime = timeBegan else{
                return
            }
            if userLocation.distance(from: CLLocation(latitude: lift.value.coordinate.latitude, longitude: lift.value.coordinate.longitude)) > radius
            {
                print("no longer waiting in line")
                isWaitingInLine = false
                lift.value.times?.append(Date.now.timeIntervalSince(startTime))
                liftWaiting = nil
                timeBegan = nil
                guard let id = lift.value.id, let times = lift.value.times else { print("lift does not have id or times"); return }
                updatePointTime(point: PointTimeUpdateData(id: id, time: times as! [Float]), completion: {
                    result in
                    guard let point = try? result.get() else {
                        print("test point update Success \(result)")
                        return
                    }
                    print(point)
                })
            }
        }
        guard let initialRegion = Self.initialRegion else { return }
        if locations[0].distance(from: CLLocation(latitude: initialRegion.center.latitude, longitude: initialRegion.center.longitude)) <= 7000
        {
            saveUserLocation(UserLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude, timeReported: "\(locations[0].timestamp)", userID: currentUserId))
        }
        
    }
}
