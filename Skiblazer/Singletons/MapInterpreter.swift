//
//  MapInterpreter.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/5/24.
//
import CoreLocation
import SwiftUI

final class MapInterpreter: ObservableObject
{
    static var shared = MapInterpreter()
    @Published var difficultyGraph = EdgeWeightedDigraph<Point>()
    @Published var distanceGraph = EdgeWeightedDigraph<Point>()
    @Published var baseLiftVertexes = [Vertex<Point>]()
    @Published var trailReports = [TrailReport]()
    
    func createMap(map: MapInfo) async throws
    {
        var trails = [Trail]()
        
        trails.append(contentsOf: map.easyTrails.features.map { self.transformFeatureToTrail($0, .easy) })
        trails.append(contentsOf: map.intermediateTrails.features.map { self.transformFeatureToTrail($0, .intermediate) })
        trails.append(contentsOf: map.advancedTrails.features.map { self.transformFeatureToTrail($0, .advanced) })
        trails.append(contentsOf: map.expertsOnlyTrails.features.map { self.transformFeatureToTrail($0, .expertsOnly) })
        trails.append(contentsOf: map.terrainParks.features.map { self.transformFeatureToTrail($0, .terrainPark) })
        trails.append(contentsOf: map.connectors.features.map { self.transformFeatureToTrail($0, .connector) })
        trails.append(contentsOf: map.lifts.features.map { self.transformFeatureToTrail($0, .lift) })
        
        let difficultyGraph = self.createGraph(vertices: self.createVertices(trails: trails), weightCaclulation: self.difficultyWeightCalculation)
        let distanceGraph = self.createGraph(vertices: self.createVertices(trails: trails), weightCaclulation: self.distanceWeightCalculation)
        self.difficultyGraph = difficultyGraph
        self.distanceGraph = distanceGraph
        
        try await self.assignTrailReportsFromDB(map: map.map)
    }
    
    private func transformFeatureToTrail(_ feature: Feature, _ difficulty: Difficulty) -> Trail
    {
        return .init(title: feature.name, difficulty: difficulty, coordinates: feature.geometry.coordinates)
    }
    
    private func createVertices(trails: [Trail]) -> [Vertex<Point>]
    {
        var foundTrails: [String] = []
        var vertices = [Vertex<Point>]()
        self.baseLiftVertexes.removeAll()
        
        for trail in trails
        {
            if !foundTrails.contains(trail.title)
            {
                foundTrails.append(trail.title)
            }
            if trail.difficulty == .lift
            {
                self.baseLiftVertexes.append(Vertex(.init(coordinate: trail.coordinates[0], title: trail.title, difficulty: trail.difficulty)))
            }
            var vertex: Vertex<Point>
            for coordinate in trail.coordinates
            {
                vertex = Vertex<Point>(.init(coordinate: coordinate, title: trail.title, difficulty: trail.difficulty))
                vertices.append(vertex)
            }
        }
        return vertices
    }
    
    private func createGraph(vertices: [Vertex<Point>], weightCaclulation: (_ vertex1: Vertex<Point>, _ vertex2: Vertex<Point>) -> Double) -> EdgeWeightedDigraph<Point>
    {
        let graph = EdgeWeightedDigraph<Point>()
        var prevVertex = vertices[0]
        graph.addVertex(prevVertex)
        for vertex in vertices
        {
            let weight = weightCaclulation(prevVertex, vertex)

            if vertex.value.title == prevVertex.value.title
            {
                vertex.value.difficulty == .connector ? graph.addEdge(direction: .undirected, from: prevVertex, to: vertex, weight: weight) : graph.addEdge(direction: .directed, from: prevVertex, to: vertex, weight: weight)
            }
            
            graph.addVertex(vertex)
            prevVertex = vertex
        }

        self.addIntersectingPointsTo(graph: graph)
        print("Finished Graph with \(graph.verticesCount()) Vertices and \(graph.edgesCount()) Edges")
        return graph
    }
    
    private func distanceWeightCalculation(_ vertex1: Vertex<Point>, _ vertex2: Vertex<Point>) -> Double
    {
        return CLLocation(latitude: vertex1.value.coordinate.latitude, longitude: vertex1.value.coordinate.longitude).distance(from: CLLocation(latitude: vertex2.value.coordinate.latitude, longitude: vertex2.value.coordinate.longitude))
    }
    
    private func difficultyWeightCalculation(_ vertex1: Vertex<Point>, _ vertex2: Vertex<Point>) -> Double
    {
        var weight: Double
        switch vertex2.value.difficulty
        {
        case .connector:
            weight = 1
        case .easy:
            weight = 1
        case .intermediate:
            weight = 50
        case .advanced:
            weight = 300
        case .lift:
            weight = 100
        case .terrainPark:
            weight = 50
        case .expertsOnly:
            weight = 1000
        }
        return weight
    }
    
    private func addIntersectingPointsTo(graph: EdgeWeightedDigraph<Point>)
    {
        var previousIntersectingEdges: [DirectedEdge<Point>] = []
        for vertex in graph.vertices
        {
            if !self.getIntersectingPoints(graph: graph, vertex: vertex).isEmpty
            {
                // print("From: \(vertex.value.title!) with coordinate: \(vertex.value.coordinate)")
                for point in self.getIntersectingPoints(graph: graph, vertex: vertex)
                {
                    if previousIntersectingEdges.contains(DirectedEdge(source: point, destination: vertex, weight: 0)) || previousIntersectingEdges.contains(DirectedEdge(source: vertex, destination: point, weight: 0))
                    {
                        // print("test")
                        continue
                    }
                    // print("To: \(point.value.title!) with coordiante: \(vertex.value.coordinate)")
                    graph.addEdge(direction: .undirected, from: point, to: vertex, weight: 0)
                    previousIntersectingEdges.append(DirectedEdge(source: vertex, destination: point, weight: 0))
                    previousIntersectingEdges.append(DirectedEdge(source: point, destination: vertex, weight: 0))
                }
            }
        }
    }
    
    /// getTrailReportsFromDB void -> void
    /// Attempts to connect to database and adds any found trailReports to myMap
    private func assignTrailReportsFromDB(map: Map) async throws
    {
        try await map.trailReports?.fetch()
        
        guard let trailReports = map.trailReports else { return }
           
        for report in trailReports
        {
            let point = Point(coordinate: .init(latitude: report.latitude, longitude: report.longitude), title: report.type.rawValue, difficulty: .easy)
            
            if let closestVertex = try? self.getClosestPoint(origin: point.coordinate, graph: self.distanceGraph)
            {
                closestVertex.value.trailReport = report
            }
            
            if let closestVertex = try? self.getClosestPoint(origin: point.coordinate, graph: self.difficultyGraph)
            {
                closestVertex.value.trailReport = report
            }
                
//            NotificationCenter.default.post(name: Notification.Name.Names.createNotification, object: nil, userInfo: ["report": report])
        }
        self.trailReports = trailReports.elements
//        NotificationCenter.default.post(name: Notification.Name.Names.configureTrailSelector, object: nil)
//        NotificationCenter.default.post(Notification(name: Notification.Name.Names.updateInitialRegion, userInfo: ["initialRegionLatitude": Double(map.initialLocationLatitude), "initialRegionLongitude": Double(map.initialLocationLongitude)]))
    }
    
    private func getClosestPoint(origin: CLLocationCoordinate2D, graph: EdgeWeightedDigraph<Point>) throws -> Vertex<Point>
    {
        guard var closestVertex = graph.vertices.first
        else
        {
            throw GraphErrors.selectedGraphHasNoVerticesError
        }
        for vertex in graph.vertices
        {
            if sqrt(pow(vertex.value.coordinate.latitude - origin.latitude, 2) + pow(vertex.value.coordinate.longitude - origin.longitude, 2)) < sqrt(pow(closestVertex.value.coordinate.latitude - origin.latitude, 2) + pow(closestVertex.value.coordinate.longitude - origin.longitude, 2))
            {
                closestVertex = vertex
            }
        }
        return closestVertex
    }
    
    private func getIntersectingPoints(graph: EdgeWeightedDigraph<Point>, vertex: Vertex<Point>) -> [Vertex<Point>]
    {
        return graph.vertices.filter(({ $0.value.title != vertex.value.title && $0.value.coordinate == vertex.value.coordinate }))
    }
}
