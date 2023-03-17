import Foundation
import MapKit

final class MapInterpreter: NSObject {
    static let shared = MapInterpreter()
    let mapView = MKMapView()
    var difficultyGraph = EdgeWeightedDigraph<ImageAnnotation>()
    var timeGraph = EdgeWeightedDigraph<ImageAnnotation>()
    var distanceGraph = EdgeWeightedDigraph<ImageAnnotation>()
    var baseLiftVertexes = [Vertex<ImageAnnotation>]()
    let baseURL = APIHandler.baseURL
    
    func createMap(map: Map)
    {
        self.mapView.removeOverlays(self.mapView.overlays)
        var polylines = [CustomPolyline]()
        for trail in map.mapTrail
        {
            var coordinates : [CLLocationCoordinate2D] = []
            var trailTimes : [[Double]] = []
            var pointIds: [String] = []
            var difficulty : Difficulty = .expertsOnly
            var color = UIColor.Theme.expertsOnlyColor
            
            switch trail.difficulty
            {
            case Difficulty.easy.rawValue:
                difficulty = .easy
                color = .Theme.easyColor
            case Difficulty.intermediate.rawValue:
                difficulty = .intermediate
                color = .Theme.intermediateColor
            case Difficulty.advanced.rawValue:
                difficulty = .advanced
                color = .Theme.advancedColor
            case Difficulty.lift.rawValue:
                difficulty = .lift
                color = .Theme.liftsColor
            case Difficulty.terrainPark.rawValue:
                difficulty = .terrainPark
                color = .Theme.terrainParksColor
            default:
                break
            }
            
            for point in trail.points
            {
                coordinates.append(CLLocationCoordinate2D(latitude: Double(point.latitude), longitude: Double(point.longitude)))
                pointIds.append(point.id!)
                trailTimes.append(point.time as! [Double])
            }
            
            let polyline = CustomPolyline(coordinates: coordinates, count: coordinates.count)
            polyline.title = trail.name
            polyline.color = color
            
            let initialAnnotation = createAnnotation(title: trail.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: difficulty)
            initialAnnotation.trailTimes = trailTimes
            initialAnnotation.ids = pointIds
            polyline.initialAnnotation = initialAnnotation
            polylines.append(polyline)
        }
        
        for connector in map.mapConnector
        {
            var coordinates : [CLLocationCoordinate2D] = []
            var trailTimes : [[Double]] = []
            var pointIds: [String] = []
            for point in connector.points
            {
                coordinates.append(CLLocationCoordinate2D(latitude: Double(point.latitude), longitude: Double(point.longitude)))
                pointIds.append(point.id!)
                trailTimes.append(point.time as! [Double])
            }
            
            let initialAnnotation = createAnnotation(title: connector.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: .easy)
            initialAnnotation.isConnector = true
            initialAnnotation.trailTimes = trailTimes
            initialAnnotation.ids = pointIds
            
            let polyline = CustomPolyline(coordinates: coordinates, count: coordinates.count)
            polyline.title = connector.name
            polyline.color = UIColor(hex: "#00be00ff")
            polyline.initialAnnotation = initialAnnotation
            polylines.append(polyline)
        }

        self.mapView.addOverlays(polylines)
        DispatchQueue.global().async{
            let vertices = self.createVertices(polylines: polylines)
            self.difficultyGraph = self.createGraph(vertices: vertices, weightCaclulation: self.difficultyWeightCalculation)
            self.timeGraph = self.createGraph(vertices: vertices, weightCaclulation: self.timeWeightCalculation)
            self.distanceGraph = self.createGraph(vertices: vertices, weightCaclulation: self.distanceWeightCalculation)
            self.assignTrailReportsFromDB(map: map)
        }
    }
    
    private func createVertices(polylines: [CustomPolyline]) -> [Vertex<ImageAnnotation>] {
        var foundTrails : [String] = []
        var vertices = [Vertex<ImageAnnotation>]()
        
        for polylineIndex in 0...polylines.count - 1
        {
            guard let initialAnnotation = polylines[polylineIndex].initialAnnotation else {
                print("Polyline Configured Incorrectly")
                continue
            }
            let overlay = polylines[polylineIndex]
            if !foundTrails.contains(overlay.title!)
            {
                self.mapView.addAnnotation(initialAnnotation)
                foundTrails.append(overlay.title!)
            }
            if initialAnnotation.difficulty == .lift
            {
                self.baseLiftVertexes.append(Vertex(initialAnnotation))
            }
            var vertex : Vertex<ImageAnnotation>
            for index in 0..<overlay.pointCount
            {
                vertex = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
                vertex.value.id = overlay.initialAnnotation?.ids![index]
                vertex.value.times = overlay.initialAnnotation?.trailTimes![index]
                vertices.append(vertex)
            }
        }
        return vertices
    }
    
    private func createGraph(vertices: [Vertex<ImageAnnotation>], weightCaclulation: (_ vertex1: Vertex<ImageAnnotation>, _ vertex2: Vertex<ImageAnnotation>) -> Double) -> EdgeWeightedDigraph<ImageAnnotation> {
        let graph = EdgeWeightedDigraph<ImageAnnotation>()
        var prevVertex = vertices[0]
        graph.addVertex(prevVertex)
        for index in 1..<vertices.count {
            let weight = weightCaclulation(prevVertex, vertices[index])

            if vertices[index].value.title == prevVertex.value.title {
                vertices[index].value.isConnector ? graph.addEdge(direction: .undirected, from: prevVertex, to: vertices[index], weight: weight) : graph.addEdge(direction: .directed, from: prevVertex, to: vertices[index], weight: weight)
            }
            
            graph.addVertex(vertices[index])
            prevVertex = vertices[index]
        }

        self.addIntersectingPointsTo(graph: graph)
        print("Finished Graph with \(graph.verticesCount()) Vertices and \(graph.edgesCount()) Edges")
        return graph
    }
    
    private func distanceWeightCalculation(_ vertex1: Vertex<ImageAnnotation>, _ vertex2: Vertex<ImageAnnotation>) -> Double {
        return CLLocation(latitude: vertex1.value.coordinate.latitude, longitude: vertex1.value.coordinate.longitude).distance(from: CLLocation(latitude: vertex2.value.coordinate.latitude, longitude: vertex2.value.coordinate.longitude))
    }
    
    private func difficultyWeightCalculation(_ vertex1: Vertex<ImageAnnotation>, _ vertex2: Vertex<ImageAnnotation>) -> Double {
        var weight : Double
        switch vertex2.value.difficulty! {
        case Difficulty.easy:
            weight = 1
        case Difficulty.intermediate:
            weight = 50
        case Difficulty.advanced:
            weight = 300
        case Difficulty.lift:
            weight = 100
        case Difficulty.terrainPark:
            weight = 50
        case Difficulty.expertsOnly:
            weight = 1000
        }
        return weight
    }
    
    private func timeWeightCalculation(_ vertex1: Vertex<ImageAnnotation>, _ vertex2: Vertex<ImageAnnotation>) -> Double {
        let weightArray = vertex2.value.times!
        return weightArray.reduce(0.0, +) / Double(weightArray.count)
    }
    
    private func addIntersectingPointsTo(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        var previousIntersectingEdges : [DirectedEdge<ImageAnnotation>] = []
        for vertex in graph.vertices
        {
            if !self.getIntersectingPoints(graph: graph, vertex: vertex).isEmpty
            {
                //print("From: \(vertex.value.title!) with coordinate: \(vertex.value.coordinate)")
                for point in self.getIntersectingPoints(graph: graph, vertex: vertex)
                {
                    if previousIntersectingEdges.contains(DirectedEdge(source: point, destination: vertex, weight: 0)) || previousIntersectingEdges.contains(DirectedEdge(source: vertex, destination: point, weight: 0))
                    {
                        //print("test")
                        continue
                    }
                    //print("To: \(point.value.title!) with coordiante: \(vertex.value.coordinate)")
                    graph.addEdge(direction: .undirected, from: point, to: vertex, weight: 0)
                    previousIntersectingEdges.append(DirectedEdge(source: vertex, destination: point, weight: 0))
                    previousIntersectingEdges.append(DirectedEdge(source: point, destination: vertex, weight: 0))
                }
            }
        }
    }
    
    ///getTrailReportsFromDB void -> void
    ///Attempts to connect to database and adds any found trailReports to myMap
    private func assignTrailReportsFromDB(map: Map)
    {
        APIHandler.shared.getTrailReports(completion: { [self] value in
            guard let trailReports = try? value.get() else
            {
                print("Error: \(value)")
                return
            }
            for report in trailReports
            {
                let latitude = report.latitude
                let longitude = report.longitude
                let annotation = createAnnotation(title: nil, latitude: latitude, longitude: longitude, difficulty: .easy)
                annotation.subtitle = "\(report.type)"
                annotation.id = report.id
    
                var closestTrail = self.getClosestAnnotation(graph: distanceGraph, origin: annotation).value
                closestTrail.trailReport = annotation
                
                closestTrail = self.getClosestAnnotation(graph: difficultyGraph, origin: annotation).value
                closestTrail.trailReport = annotation
                
                closestTrail = self.getClosestAnnotation(graph: timeGraph, origin: annotation).value
                closestTrail.trailReport = annotation
                
                self.mapView.addAnnotation(annotation)
                guard InteractiveMapViewController.currentUser.alertSettings.contains(report.type) else { continue }
                NotificationCenter.default.post(name: Notification.Name.Names.createNotification, object: nil, userInfo: ["report": report])
            }
            NotificationCenter.default.post(name: Notification.Name.Names.configureTrailSelector, object: nil)
            NotificationCenter.default.post(Notification(name: Notification.Name.Names.updateInitialRegion, userInfo: ["initialRegionLatitude": Double(map.initialLocationLatitude), "initialRegionLongitude": Double(map.initialLocationLongitude), "trailReports": trailReports]))
            
        })
    }
    
    /// getClosestAnnotation: ImageAnnotation -> Vertex<ImageAnnotation>
    /// paramaters:
    ///     - origin: The annotation you want to find the nearest annotation for
    /// Finds the annotation the least distacne from the passed in origin
    private func getClosestAnnotation(graph: EdgeWeightedDigraph<ImageAnnotation>, origin: ImageAnnotation) -> Vertex<ImageAnnotation>
    {
        var closestAnnotation = graph.vertices[0]
        for annotation in graph.vertices
        {
            if(sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < (sqrt(pow(closestAnnotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + (pow(closestAnnotation.value.coordinate.longitude - origin.coordinate.longitude, 2)))))
            {
                closestAnnotation = annotation
            }
        }
        return closestAnnotation
    }
    
    private func getIntersectingPoints(graph: EdgeWeightedDigraph<ImageAnnotation>, vertex: Vertex<ImageAnnotation>) -> [Vertex<ImageAnnotation>]
    {
        return graph.vertices.filter(({$0.value.title != vertex.value.title && $0.value.coordinate == vertex.value.coordinate}))
    }
    
    private func getClosestPoint(graph: EdgeWeightedDigraph<ImageAnnotation>, vertex: Vertex<ImageAnnotation>) -> Vertex<ImageAnnotation>
    {
        var closestVertex: Vertex<ImageAnnotation> = graph.vertices.filter({$0 != vertex})[0]
        for point in graph.vertices.filter({$0 != vertex})
        {
            if((sqrt(pow(point.value.coordinate.latitude - vertex.value.coordinate.latitude, 2) + pow(point.value.coordinate.longitude - vertex.value.coordinate.longitude, 2))) < (sqrt(pow(closestVertex.value.coordinate.latitude - vertex.value.coordinate.latitude, 2) + (pow(closestVertex.value.coordinate.longitude - vertex.value.coordinate.longitude, 2)))))
            {
                closestVertex = point
            }
        }
        return closestVertex
    }
    
}

extension CLLocationCoordinate2D: Equatable
{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool
    {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
