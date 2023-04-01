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
            do {
                let pathToDestination = try self.createRoute(origin: origin, destination: destination)
                DispatchQueue.main.async { [self] in
                    var directions = ""
                    var trailReports = ""
                    var count = 0
                    var foundAnnotations : [ImageAnnotation] = []
                    let mapImageAnnotations = self.interactiveMapView.annotations.filter({$0 as? ImageAnnotation != nil}) as! [ImageAnnotation]
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
                        self.interactiveMapView.removeAnnotations(self.interactiveMapView.annotations)
                        self.interactiveMapView.addAnnotations(foundAnnotations)
                        if let trailReport = (vertex.value.trailReport)
                        {
                            trailReports.append("\(trailReport.subtitle!) ")
                        }
                    }
                    self.loadingScreen.isHidden = true
                    if(!self.routeInProgress)
                    {
                        do {
                            self.initialLocation = try self.getClosestAnnotation(origin: origin ?? self.assignOrigin().value).value.title
                        } catch {
                            self.handle(error: error)
                        }
                        self.routeOverviewView.configureOverview(trip: "\(origin?.title ?? "Your Location") -> \(destination.title!)", trailReports: trailReports, totalDirections: directions, count: count)
                        self.routeOverviewMenu.presentItems()
                        self.displayRoute(origin: origin, destination: destination)
                        self.routeInProgress = true
                        
                        let zoomSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(180), longitudeDelta: CLLocationDegrees(180))
                        let zoomCoordinate = destination.coordinate
                        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
                        self.interactiveMapView.setRegion(zoomed, animated: true)
                    }
                    return
                }
            } catch {
                DispatchQueue.main.async{
                    self.selectedGraph.removeVertices({$0.value.title == "Your Location"})
                    self.loadingScreen.isHidden = true
                    self.handle(error: error)
                }
                return
            }
        }
    }
    
    /// createRoute: void -> [Vertex<ImageAnnotatioin>] || null
    /// Creates a route for the easiest path from the users location to the selected destination
    func createRoute(origin: ImageAnnotation?, destination: ImageAnnotation) throws -> [Vertex<ImageAnnotation>]
    {
        guard let origin = origin else {
            do {
                return try self.manageRouteInProgress(originVertex: assignOrigin(), destination: destination)
            } catch {
                throw error
            }
        }
        var originVertex = Vertex<ImageAnnotation>(origin)
        var found = false
        for vertex in self.selectedGraph.vertices
        {
            if vertex.value == originVertex.value{
                originVertex = vertex
                found = true
                break
            }
        }
        if found
        {
            do {
                return try self.manageRouteInProgress(originVertex: originVertex, destination: destination)
            } catch {
                throw error
            }
        }
        //something went wrong and couldnt find vertex that matches the selected origin (this should never happen)
        throw RoutingErrors.originNotFoundError
    }

    private func manageRouteInProgress(originVertex: Vertex<ImageAnnotation>, destination: ImageAnnotation) throws -> [Vertex<ImageAnnotation>]
    {
        do {
            let closestVertex = try self.getClosestAnnotation(origin: originVertex.value)
            
            guard !self.userDidCompleteRoute(closestVertex: closestVertex, destination: destination) else {
                //Then youve completed your journey
                //figure out something to do buckoh
                DispatchQueue.main.async {
                    self.cancelRoute()
                }
                
                guard let currentUserId = Self.currentUser.id else  {
                    return []
                }
                
                APIHandler.shared.saveUserRoute(UserRoute(destinationTrailName: destination.title!, originTrailName: self.initialLocation!, dateMade: "\(Date.now)", timeTook: Int(Date.now.timeIntervalSince(timer)), userID: currentUserId))
                
                return []
            }
            
            guard self.routeInProgress && self.pathCreated.contains(closestVertex) else {
                self.selectedGraph.addVertex(originVertex)
                self.selectedGraph.addEdge(direction: .undirected, from: originVertex, to: closestVertex, weight: 1)
                return try createRouteHelper(graph: self.selectedGraph, originVertex: originVertex, destination: destination)
            }
            
            self.pathCreated.removeAll(where: {$0.value.title == "Your Location"})
            
            for vertex in self.pathCreated {
                if vertex == closestVertex {
                    break
                }
                self.pathCreated.removeFirst()
            }
            
            self.pathCreated.insert(originVertex, at: 0)
            
            let pathGraph = EdgeWeightedDigraph<ImageAnnotation>()
            
            for index in 0...self.pathCreated.count - 1
            {
                pathGraph.addVertex(self.pathCreated[index])
            }
            
            pathGraph.addEdge(direction: .undirected, from: originVertex, to: closestVertex, weight: 1)
            
            print("path graph with \(pathGraph.verticesCount()) vertices and \(pathGraph.edgesCount()) edges")
            return try createRouteHelper(graph: pathGraph, originVertex: originVertex, destination: destination)
            
        } catch {
            throw error
        }
        
    }
    
    private func createRouteHelper(graph: EdgeWeightedDigraph<ImageAnnotation>, originVertex: Vertex<ImageAnnotation>, destination: ImageAnnotation) throws ->  [Vertex<ImageAnnotation>]
    {
        let startTime = Date.now
        var destinationVertex = graph.vertices.first(where: {$0.value == destination})
        if destinationVertex == nil {
            destinationVertex = graph.vertices.first(where: {$0.value.title == destination.title})
        }
        guard let destination = destinationVertex else {
            throw RoutingErrors.destinationNotFoundError
        }
        if let pathToDestination = DijkstraShortestPath(graph, source: originVertex).pathTo(destination) {
            print("Took \(Date.now.timeIntervalSince(startTime)) seconds to find route")
            self.pathCreated = pathToDestination
            return pathToDestination
        }
        throw RoutingErrors.routeNotFoundError
    }
    
    private func userDidCompleteRoute(closestVertex: Vertex<ImageAnnotation>, destination: ImageAnnotation) -> Bool {
        return closestVertex.value == destination
    }
    
    /// assignOrigin: void ->  Bool
    ///  Creates an annotation for the users current location if the user allows access to its location
    private func assignOrigin() throws -> Vertex<ImageAnnotation>
    {
        guard let latitude = LocationManager.shared.location?.coordinate.latitude, let longitude = LocationManager.shared.location?.coordinate.longitude, LocationManager.shared.authorizationStatus == .authorizedWhenInUse else {
            throw RoutingErrors.userDoesNotHaveLocationServicesEnabledError
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
        let previousOverlays = self.interactiveMapView.overlays
        let previousAnnotations = self.interactiveMapView.annotations.filter({$0.isKind(of: ImageAnnotation.self)}) as! [ImageAnnotation]
        print(pathCreated.count)
        DispatchQueue.global().async {
            do {
                let newRoute = try self.createRoute(origin: origin, destination: destination)
                DispatchQueue.main.async {
                    self.displayRouteHelper(route: newRoute, previousOverlays: previousOverlays, previousAnnotations: previousAnnotations)
                }
            } catch {
                DispatchQueue.main.async {
                    self.handle(error: error)
                }
            }
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
            let polyLine = CustomPolyline(coordinates: [previousVertex.value.coordinate, vertex.value.coordinate], count: 2)
            switch previousVertex.value.difficulty
            {
            case .easy:
                polyLine.color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
            case .intermediate:
                polyLine.color = .blue
            case .advanced:
                polyLine.color = .gray
            case .lift:
                polyLine.color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
            case .terrainPark:
                polyLine.color = .orange
            default:
                polyLine.color = .black
            }
            polyLine.initialAnnotation = previousVertex.value
            self.interactiveMapView.addOverlay(polyLine, level: .aboveRoads)
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
        self.interactiveMapView.removeAnnotations(Array(set2))
        self.interactiveMapView.removeOverlays(previousOverlays)
        if self.routeInProgress {
            self.interactiveMapView.addAnnotations(foundAnnotations)
            self.connectivityController.setRoute(route: routes)
            self.canFindPathAgain = true
        }
    }
}
