//
//  Routing.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit
import MapKit

extension InteractiveMapViewController {
    
    /// sampleRoute: void -> void
    ///  Presents a routeOverviewMenu for the selected path
    func sampleRoute(origin: ImageAnnotation?, destination: ImageAnnotation)
    {
        self.searchBar.dismissExtendedView()
        guard !self.routeInProgress else
        {
            return
        }
        self.loadingScreen.isHidden = false
        
        DispatchQueue.global().async {
            guard let pathToDestination = self.createRoute(origin: origin, destination: destination) else {
                DispatchQueue.main.async{
                    if self.selectedGraph.vertices.last?.value.title! == "Your Location"
                    {
                        self.selectedGraph.removeLastVertex()
                    }
                    self.loadingScreen.isHidden = true
                }
                return
            }
            DispatchQueue.main.async { [self] in
                var directions = ""
                var trailReports = ""
                var count = 0
                var foundAnnotations : [ImageAnnotation] = []
                let mapImageAnnotations = myMap.annotations.filter({$0 as? ImageAnnotation != nil}) as! [ImageAnnotation]
                for vertex in pathToDestination
                {
                    foundAnnotations = mapImageAnnotations.filter({
                        if($0.coordinate == vertex.value.coordinate && !directions.contains($0.title!))
                        {
                            directions.append("\(vertex.value.title!); ")
                            count += 1
                            return true
                        }
                        return false
                    })
                    self.myMap.removeAnnotations(self.myMap.annotations)
                    self.myMap.addAnnotations(foundAnnotations)
                    if let trailReport = (vertex.value.trailReport)
                    {
                        trailReports.append("\(trailReport.subtitle!) ")
                    }
                }
                self.loadingScreen.isHidden = true
                if(!self.routeInProgress)
                {
                    self.initialLocation = self.getClosestAnnotation(origin: origin ?? self.assignOrigin()!.value).value.title
                    self.routeOverviewView.configureOverview(trip: "\(origin?.title ?? "Your Location") -> \(destination.title!)", trailReports: trailReports, totalDirections: directions, count: count)
                    self.routeOverviewMenu.presentItems()
                    self.displayRoute(origin: origin, destination: destination)
                    self.routeInProgress = true
                    
                    let zoomSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(180), longitudeDelta: CLLocationDegrees(180))
                    let zoomCoordinate = destination.coordinate
                    let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
                    myMap.setRegion(zoomed, animated: true)
                }
                return
            }
            
        }
    }
    
    /// createRoute: void -> [Vertex<ImageAnnotatioin>] || null
    /// Creates a route for the easiest path from the users location to the selected destination
    func createRoute(origin: ImageAnnotation?, destination: ImageAnnotation) -> [Vertex<ImageAnnotation>]?
    {
        guard let origin = origin else {
            if let origin = assignOrigin() {
                return manageRouteInProgress(originVertex: origin, destination: destination)
            }
            else {
                // The user does not have location services on
                print("User does not have location services on")
                return nil
            }
        }
        var originVertex = Vertex<ImageAnnotation>(origin)
        var found = false
        for annotation in self.selectedGraph.vertices
        {
            if annotation.value == originVertex.value{
                originVertex = annotation
                found = true
                break
            }
        }
        if found
        {
            return manageRouteInProgress(originVertex: originVertex, destination: destination)
        }
        //something went wrong and couldnt find vertex that matches the selected origin (this should never happen)
        return nil
        
    }
    private func manageRouteInProgress(originVertex: Vertex<ImageAnnotation>, destination: ImageAnnotation) -> [Vertex<ImageAnnotation>]?
    {
        let closestVertex = getClosestAnnotation(origin: originVertex.value)
        
        guard !userDidCompleteRoute(closestVertex: closestVertex, destination: destination) else {
            //Then youve completed your journey
            //figure out something to do buckoh
            self.cancelRoute()
            guard let currentUserId = Self.currentUser.id else
            {
                return nil
            }
            APIHandler.shared.saveUserRoute(UserRoute(destinationTrailName: destination.title!, originTrailName: initialLocation!, dateMade: "\(Date.now)", timeTook: Int(Date.now.timeIntervalSince(timer)), userID: currentUserId))
            return nil
        }
        
        guard self.routeInProgress && self.pathCreated.contains(closestVertex) else {
            self.selectedGraph.addVertex(originVertex)
            self.selectedGraph.addEdge(direction: .directed, from: originVertex, to: closestVertex, weight: 1)
            return createRouteHelper(graph: self.selectedGraph, originVertex: originVertex, destination: destination)
        }
        
        while self.pathCreated[0].value.title == "Your Location" {
            self.pathCreated.removeFirst()
        }
        
        self.pathCreated.insert(originVertex, at: 0)
        
        let pathGraph = EdgeWeightedDigraph<ImageAnnotation>()
        for index in 1...self.pathCreated.count - 1
        {
            pathGraph.addVertex(self.pathCreated[index])
        }
        
        print("path graph with \(pathGraph.verticesCount()) vertices and \(pathGraph.edgesCount()) edges")
        return createRouteHelper(graph: pathGraph, originVertex: originVertex, destination: destination)
        
    }
    
    private func createRouteHelper(graph: EdgeWeightedDigraph<ImageAnnotation>, originVertex: Vertex<ImageAnnotation>, destination: ImageAnnotation) -> [Vertex<ImageAnnotation>]?
    {
        let startTime = Date.now
        var destinationVertex = graph.vertices.first(where: {$0.value == destination})
        if destinationVertex == nil
        {
            destinationVertex = graph.vertices.first(where: {$0.value.title == destination.title})
        }
        if let pathToDestination = DijkstraShortestPath(graph, source: originVertex).pathTo(destinationVertex!)
        {
            print("Took \(Date.now.timeIntervalSince(startTime)) seconds to find route")
            self.pathCreated = pathToDestination
            return pathToDestination
        }
        return nil
    }
    
    fileprivate func userDidCompleteRoute(closestVertex: Vertex<ImageAnnotation>, destination: ImageAnnotation) -> Bool {
        return closestVertex.value == destination
    }
    
    /// assignOrigin: void ->  Bool
    ///  Creates an annotation for the users current location if the user allows access to its location
    private func assignOrigin() -> Vertex<ImageAnnotation>?
    {
        guard let latitude = locationManager.locationManager.location?.coordinate.latitude, let longitude = locationManager.locationManager.location?.coordinate.longitude, locationManager.locationManager.authorizationStatus == .authorizedWhenInUse else {
            return nil
        }
        let origin = createAnnotation(title: "Your Location", latitude: latitude, longitude: longitude, difficulty: .easy)
        return Vertex<ImageAnnotation>(origin)
    }
    
    
    
    @objc func presentFullDirections(fullDirections: String)
    {
        //show some sort of direction pop up
        print(fullDirections)
    }
    
    /// displayRoute: void -> void
    /// Shows the selected route on the map
    func displayRoute(origin: ImageAnnotation?, destination: ImageAnnotation)
    {
        let previousOverlays = myMap.overlays
        let previousAnnotations = myMap.annotations.filter({$0.isKind(of: ImageAnnotation.self)}) as! [ImageAnnotation]
        print(pathCreated.count)
        DispatchQueue.global().async {
            if let newRoute = self.createRoute(origin: origin, destination: destination)
            {
                DispatchQueue.main.async {
                    self.displayRouteHelper(route: newRoute, previousOverlays: previousOverlays, previousAnnotations: previousAnnotations)
                }
                
            }
            self.canFindPathAgain = true
            return
        }
    }
    
    func displayRouteHelper(route: [Vertex<ImageAnnotation>], previousOverlays: [MKOverlay], previousAnnotations: [ImageAnnotation])
    {
        var previousVertex = route[0]
        var foundAnnotations : [ImageAnnotation] = []
        var routes : [Route] = []
        var id = 0
        var foundTrails : [String] = []
        for vertex in route{
            myPolyLine = CustomPolyline(coordinates: [previousVertex.value.coordinate, vertex.value.coordinate], count: 2)
            switch previousVertex.value.difficulty
            {
            case .easy:
                myPolyLine.color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
            case .intermediate:
                myPolyLine.color = .blue
            case .advanced:
                myPolyLine.color = .gray
            case .lift:
                myPolyLine.color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
            case .terrainPark:
                myPolyLine.color = .orange
            default:
                myPolyLine.color = .black
            }
            myPolyLine.initialAnnotation = previousVertex.value
            myMap.addOverlay(myPolyLine, level: .aboveRoads)
            if let trailReport = vertex.value.trailReport
            {
                foundAnnotations.append(trailReport)
            }
            if (!foundTrails.contains(vertex.value.title!))
            {
                foundTrails.append(vertex.value.title!)
                foundAnnotations.append(vertex.value)
                routes.append(Route(id: id, annotationName: vertex.value.title!, coordinates: [vertex.value.coordinate.latitude, vertex.value.coordinate.longitude]))
            }
            id += 1
            previousVertex = vertex
        }
        let set1 = Set(previousAnnotations)
        let set2 = set1.subtracting(foundAnnotations)
        myMap.removeAnnotations(Array(set2))
        myMap.removeOverlays(previousOverlays)
        if self.routeInProgress {
            myMap.addAnnotations(foundAnnotations)
            connectivityController.setRoute(route: routes)
            self.canFindPathAgain = true
        }
    }
}
