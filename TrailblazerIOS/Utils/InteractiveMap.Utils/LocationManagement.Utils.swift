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
        
        guard let currentUserId = Self.currentUser.id else {
            return
        }
        
        let userLocation = locations[0]

        if !self.isWaitingInLine {
            for vertex in MapInterpreter.shared.baseLiftVertexes{
                let liftLocation = CLLocation(latitude: vertex.value.coordinate.latitude, longitude: vertex.value.coordinate.longitude)
                if userLocation.distance(from: liftLocation) <= self.radius
                {
                    self.isWaitingInLine = true
                    self.liftWaiting = vertex
                    self.timeBegan = Date.now
                    print("isWaiting in line for lift \(String(describing: self.liftWaiting?.value.title))")
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
                isWaitingInLine = false
                liftWaiting = nil
                timeBegan = nil
                guard let id = lift.value.id, var times = lift.value.times else { print("lift does not have id or times"); return }
                times.append(Date.now.timeIntervalSince(startTime))
                APIHandler.shared.updatePointTime(point: PointTimeUpdateData(id: id, time: times), completion: {
                    result in
                    do {
                        let point = try result.get()
                        lift.value.times = point.time
                        print(point)
                    } catch {
                        print(error)
                    }
                })
            }
        }

        if locations[0].distance(from: CLLocation(latitude: self.interactiveMapView.center.x, longitude: self.interactiveMapView.center.y)) <= 7000
        {
//            APIHandler.shared.saveUserLocation(UserLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude, timeReported: "\(locations[0].timestamp)", userID: currentUserId))
        }
        
    }
}
