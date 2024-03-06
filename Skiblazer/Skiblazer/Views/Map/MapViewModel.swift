//
//  MapViewModel.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import CoreLocation
import SwiftUI

struct MapProps {}

class MapViewModel: NSObject, LoadableObject {
    @Published var state: LoadingState<MapProps> = .idle

    @Published var trailsToDisplay: [Trail] = []

    @ObservedObject var mapInterpreter = MapInterpreter.shared
    
    @ObservedObject var context = AppContext.shared
    
    @Published var routeInProgress = false
    
    @Published var currentPath: [Vertex<Point>] = []
    
    private var isLoadingRoute = false
    
    var map: Map

    init(map: Map) {
        self.map = map
        super.init()
        LocationManager.shared.delegate = self
    }

    func load() {
        self.transitionState(.loading)
        Task {
            do {
                let map = try await APIHandler.getMapInfo(self.map)
                try await self.mapInterpreter.createMap(map: map)
                
                let points = self.mapInterpreter.difficultyGraph.vertices.map { $0.value }

                let trails = self.transformPointsToTrails(points)
                DispatchQueue.main.async {
                    AppContext.shared.selectedGraph = self.mapInterpreter.difficultyGraph
                    self.trailsToDisplay = trails
                    self.load(.init())
                }
            } catch {
                self.fail(error, .init())
            }
        }
    }

    func onPolylineClicked(_ trail: Trail) {
        self.transitionState(.loading)
        self.routeInProgress = true
        self.findAndDisplayRoute(destination: trail.firstPoint)
    }
    
    func findAndDisplayRoute(_ origin: Point? = nil, destination: Point) {
        DispatchQueue.global().async {
            do {
                defer {
                    self.isLoadingRoute = false
                }
                
                self.isLoadingRoute = true
                let points = try self.createRoute(origin: origin, destination: destination, graph: self.context.selectedGraph)
                let trails = self.transformPointsToTrails(points.map { $0.value })
                DispatchQueue.main.async {
                    self.trailsToDisplay = trails
                    self.load(.init())
                }
            } catch {
                self.routeInProgress = false
                self.fail(error, .init())
            }
        }
    }
    
    private func transformPointsToTrails(_ points: [Point]) -> [Trail] {
        var trails = [Trail]()

        for point in points {
            if let index = trails.firstIndex(where: { $0.title == point.title }) {
                trails[index].coordinates.append(point.coordinate)
            } else {
                trails.append(.init(title: point.title, difficulty: point.difficulty, coordinates: [point.coordinate]))
            }
        }
        
        return trails
    }
    
    /// createRoute: void -> [Vertex<ImageAnnotatioin>] || null
    /// Creates a route for the easiest path from the users location to the selected destination
    func createRoute(origin: Point? = nil, destination: Point, graph: EdgeWeightedDigraph<Point>) throws -> [Vertex<Point>] {
        guard let origin = origin else {
            do {
                return try self.manageRouteInProgress(originVertex: self.assignOrigin(), destination: destination, graph: graph)
            } catch {
                throw error
            }
        }
        var originVertex = Vertex<Point>(origin)
        var found = false
        for vertex in graph.vertices {
            if vertex.value == originVertex.value {
                originVertex = vertex
                found = true
                break
            }
        }
        if found {
            do {
                return try self.manageRouteInProgress(originVertex: originVertex, destination: destination, graph: graph)
            } catch {
                throw error
            }
        }
        // something went wrong and couldnt find vertex that matches the selected origin (this should never happen)
        throw RoutingErrors.originNotFoundError
    }
    
    private func manageRouteInProgress(originVertex: Vertex<Point>, destination: Point, graph: EdgeWeightedDigraph<Point>) throws -> [Vertex<Point>]
    {
        do {
            let closestVertex = try self.getClosestAnnotation(origin: originVertex.value, graph: graph)
            
            guard !self.userDidCompleteRoute(closestVertex: closestVertex, destination: destination) else {
                // Then youve completed your journey
                // figure out something to do buckoh
                DispatchQueue.main.async {
//                    self.cancelRoute()
                }
                
//                guard let currentUserId = Self.currentUser.id else {
//                    return []
//                }
                
//                APIHandler.shared.saveUserRoute(UserRoute(destinationTrailName: destination.title!, originTrailName: self.initialLocation!, dateMade: "\(Date.now)", timeTook: Int(Date.now.timeIntervalSince(timer)), userID: currentUserId))
                
                return []
            }
            
            guard self.routeInProgress && self.currentPath.contains(closestVertex) else {
                graph.addVertex(originVertex)
                graph.addEdge(direction: .undirected, from: originVertex, to: closestVertex, weight: 1)
                return try self.createRouteHelper(graph: graph, originVertex: originVertex, destination: destination)
            }
            
            var pathGraph = self.currentPath
            
            pathGraph.removeAll(where: { $0.value.title == "Your Location" })
            
            for vertex in pathGraph {
                if vertex == closestVertex {
                    break
                }
                pathGraph.removeFirst()
            }
            
            pathGraph.insert(originVertex, at: 0)
            
            let newGraph = EdgeWeightedDigraph<Point>()
            
            for vertex in pathGraph {
                newGraph.addVertex(vertex)
            }
            
            newGraph.addEdge(direction: .undirected, from: originVertex, to: closestVertex, weight: 1)
            
            print("path graph with \(newGraph.verticesCount()) vertices and \(newGraph.edgesCount()) edges")
            return try self.createRouteHelper(graph: newGraph, originVertex: originVertex, destination: destination)
            
        } catch {
            throw error
        }
    }
    
    private func createRouteHelper(graph: EdgeWeightedDigraph<Point>, originVertex: Vertex<Point>, destination: Point) throws -> [Vertex<Point>]
    {
        let startTime = Date.now
        var destinationVertex = graph.vertices.first(where: { $0.value == destination })
        if destinationVertex == nil {
            destinationVertex = graph.vertices.first(where: { $0.value.title == destination.title })
        }
        guard let destination = destinationVertex else {
            throw RoutingErrors.destinationNotFoundError
        }
        if let pathToDestination = DijkstraShortestPath(graph, source: originVertex).pathTo(destination) {
            print("Took \(Date.now.timeIntervalSince(startTime)) seconds to find route")
            DispatchQueue.main.async {
                self.currentPath = pathToDestination
            }
            return pathToDestination
        }
        throw RoutingErrors.routeNotFoundError
    }
    
    private func userDidCompleteRoute(closestVertex: Vertex<Point>, destination: Point) -> Bool {
        return closestVertex.value == destination
    }
    
    /// assignOrigin: void ->  Bool
    ///  Creates an annotation for the users current location if the user allows access to its location
    private func assignOrigin() throws -> Vertex<Point> {
        guard let latitude = LocationManager.shared.location?.coordinate.latitude, let longitude = LocationManager.shared.location?.coordinate.longitude, LocationManager.shared.authorizationStatus == .authorizedWhenInUse else {
            throw UserErrors.userDoesNotHaveLocationServicesEnabledError
        }
        let origin = Point(coordinate: .init(latitude: latitude, longitude: longitude), title: "Your Location", difficulty: .easy)
        return Vertex<Point>(origin)
    }
    
    /// getClosestAnnotation: ImageAnnotation -> Vertex<ImageAnnotation>
    /// paramaters:
    ///     - origin: The annotation you want to find the nearest annotation for
    /// Finds the annotation the least distacne from the passed in origin
    func getClosestAnnotation(origin: Point, graph: EdgeWeightedDigraph<Point>) throws -> Vertex<Point> {
        graph.removeVertices { $0.value.title == "Your Location" }
        guard var closestAnnotation = graph.vertices.first else {
            throw GraphErrors.selectedGraphHasNoVerticesError
        }
        for annotation in graph.vertices {
            if sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < sqrt(pow(closestAnnotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(closestAnnotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) {
                closestAnnotation = annotation
            }
        }
        return closestAnnotation
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated", self.routeInProgress, self.isLoadingRoute, self.currentPath.first)
        if self.routeInProgress && !self.isLoadingRoute && self.currentPath.first?.value.title == "Your Location"
        {
            
            // the last element of path created is our destination
            if let destination = self.currentPath.last?.value {
                self.findAndDisplayRoute(destination: destination)
            }
        }
        
//        guard let currentUserId = Self.currentUser.id else {
//            return
//        }
//
//        let userLocation = locations[0]
//
//        if !self.isWaitingInLine {
//            for vertex in MapInterpreter.shared.baseLiftVertexes{
//                let liftLocation = CLLocation(latitude: vertex.value.coordinate.latitude, longitude: vertex.value.coordinate.longitude)
//                if userLocation.distance(from: liftLocation) <= self.radius
//                {
//                    self.isWaitingInLine = true
//                    self.liftWaiting = vertex
//                    self.timeBegan = Date.now
//                    print("isWaiting in line for lift \(String(describing: self.liftWaiting?.value.title))")
//                    break
//                }
//            }
//        }
//        else {
//            guard let lift = liftWaiting, let startTime = timeBegan else{
//                return
//            }
//            if userLocation.distance(from: CLLocation(latitude: lift.value.coordinate.latitude, longitude: lift.value.coordinate.longitude)) > radius
//            {
//                isWaitingInLine = false
//                liftWaiting = nil
//                timeBegan = nil
//                guard let id = lift.value.id, var times = lift.value.times else { print("lift does not have id or times"); return }
//                times.append(Date.now.timeIntervalSince(startTime))
//                APIHandler.shared.updatePointTime(point: PointTimeUpdateData(id: id, time: times), completion: {
//                    result in
//                    do {
//                        let point = try result.get()
//                        lift.value.times = point.time
//                        print(point)
//                    } catch {
//                        print(error)
//                    }
//                })
//            }
//        }
//
//        if locations[0].distance(from: CLLocation(latitude: self.interactiveMapView.center.x, longitude: self.interactiveMapView.center.y)) <= 7000
//        {
        ////            APIHandler.shared.saveUserLocation(UserLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude, timeReported: "\(locations[0].timestamp)", userID: currentUserId))
//        }
    }
}
