import Foundation
import MapKit

struct Map : Codable, Equatable
{
    var id: String?
    var name: String?
    var mapTrail: [MapTrail]?
    var mapConnector: [MapConnector]?
    public static func == (lhs: Map, rhs: Map) -> Bool
    {
        return lhs.id == rhs.id
    }
}

struct MapTrail: Codable, Equatable {
    var id: String?
    var name: String?
    var map: Map?
    var points: [Point]?
    var difficulty: String?
    
    public static func == (lhs: MapTrail, rhs: MapTrail) -> Bool
    {
        return lhs.id == rhs.id
    }
}
struct Point: Codable {
    var id: String?
    var mapTrailId: MapTrail?
    var mapConnectorId: MapConnector?
    var latitude: Float
    var longitude: Float
}
struct MapConnector: Codable {
    var id: String?
    var name: String?
    var map: Map?
    var points: [Point]?
}
final class MapInterpreter: NSObject {
    static let shared = MapInterpreter()
    var mapView = MKMapView()
    let baseURL = "http://35.172.135.117"
    var map : Map?
    var graph = EdgeWeightedDigraph<ImageAnnotation>()
    override init() {
        super.init()
        
    }
    func getMap(id: String)
    {
        let url = URL(string: "\(baseURL)/api/maps/\(id)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with fetching Map: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                self.map = try decoder.decode(Map.self, from: data)
                self.getMapTrails(id: id)
            } catch {
                print("Error decoding Map: \(error)")
            }
        }.resume()
    }
    
    private func getMapTrails(id: String)
    {
        let url = URL(string: "\(baseURL)/api/maps/\(id)/map-trails")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with fetching map trails: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                self.map?.mapTrail = try decoder.decode([MapTrail].self, from: data)
                if self.map?.mapTrail != nil
                {
                    var collectedIndex = 0
                    for index in 0...self.map!.mapTrail!.count - 1
                    {
                        self.getPoints(id: self.map!.mapTrail![index].id!, isConnector: false, completion: { result in
                            guard let points = try? result.get() else
                            {
                                print("Error: \(result)")
                                return
                            }
                            self.map!.mapTrail![index].points = points
                            collectedIndex += 1
                            if collectedIndex == self.map!.mapTrail!.count
                            {
                                self.getMapConnectors(id: id, completion: {
                                    result in
                                    guard (try? result.get()) != nil else
                                    {
                                        print("Error: \(result)")
                                        return
                                    }
                                    print("testMap")
                                    self.createMap(map: self.map!)
                                })
                            }
                        })
                    }
                }
            } catch {
                print("Error decoding map trails: \(error)")
            }
        }.resume()
    }
    
    private func getMapConnectors(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
    {
        let url = URL(string: "\(baseURL)/api/maps/\(id)/map-connectors")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                self.map?.mapConnector = try decoder.decode([MapConnector].self, from: data)
                if self.map?.mapConnector != nil
                {
                    var collectedIndex = 0
                    for index in 0...self.map!.mapConnector!.count - 1
                    {
                        self.getPoints(id: self.map!.mapConnector![index].id!, isConnector: true, completion: { result in
                            guard let points = try? result.get() else
                            {
                                print("Error: \(result)")
                                return
                            }
                            collectedIndex += 1
                            self.map!.mapConnector![index].points = points
                            print(collectedIndex)
                            if collectedIndex == self.map!.mapConnector!.count
                            {
                                completion(.success(true))
                            }
                        })
                    }
                }
            } catch {
                print("Error decoding map connectors: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    private func getPoints(id: String, isConnector: Bool, completion: @escaping (Result<[Point], Error>) -> Void)
    {
        var url: URL
        if isConnector
        {
            url = URL(string: "\(baseURL)/api/map-connectors/\(id)/points")!
        }
        else
        {
            url = URL(string: "\(baseURL)/api/map-trails/\(id)/points")!
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            do {
                let decoder = JSONDecoder()
                let points = try decoder.decode([Point].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(points))
                }
            } catch {
                print("Unable to parse JSON response.")
                completion(.failure(error))
            }
            
        }.resume()
    }
    private func createMap(map: Map)
    {
        var annotations : [ImageAnnotation] = []
        var polylines: [CustomPolyline] = []
        guard let trails = map.mapTrail else {
            print("mapTrails Don't Exist")
            return
            
        }
        guard let mapConnectors = map.mapConnector else {
            print("mapConnectors Don't Exist")
            return
            
        }
        print("test")
        for trail in trails
        {
            var coordinates : [CLLocationCoordinate2D] = []
            guard let points = trail.points else {
                print("Points do not exist")
                return
            }
            for index in 0...points.count - 1
            {
                let lat = points[index].longitude
                let long = points[index].latitude
                coordinates.append(CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long)))
            }
            var difficulty : Difficulty = .easy
            var color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
            switch trail.difficulty
            {
            case "intermediate":
                difficulty = .intermediate
                color = .blue
            case "advanced" :
                difficulty = .advanced
                color = .gray
            case "experts only":
                difficulty = .expertsOnly
                color = .black
            case "lift":
                difficulty = .lift
                color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
            case "terrain park":
                difficulty = .terrainPark
                color = .orange
            default:
                break
            }
            let polyline = CustomPolyline(coordinates: coordinates, count: points.count)
            polyline.title = trail.name
            polyline.color = color
            let initialAnnotation = TrailsDatabase.createAnnotation(title: trail.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: difficulty)
            polyline.initialAnnotation = initialAnnotation
            polylines.append(polyline)
            annotations.append(polyline.initialAnnotation!)
        }
        for connector in mapConnectors
        {
            var coordinates : [CLLocationCoordinate2D] = []
            guard let points = connector.points else {
                print("Map Connector Points Don't Exist")
                return
                
            }
            for index in 0...points.count - 1
            {
                let lat = points[index].longitude
                let long = points[index].latitude
                coordinates.append(CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long)))
            }
            let polyline = CustomPolyline(coordinates: coordinates, count: points.count)
            polyline.title = connector.name
            let initialAnnotation = TrailsDatabase.createAnnotation(title: connector.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: .easy)
            initialAnnotation.isConnector = true
            polyline.color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
            polyline.initialAnnotation = initialAnnotation
            polylines.append(polyline)
        }
        mapView.addOverlays(polylines)
        mapView.addAnnotations(annotations)
        createGraph()
    }
    private func createGraph()
    {
        print("test Graph")
        let polylines = mapView.overlays.filter({$0 as? CustomPolyline != nil}) as! [CustomPolyline]
        print(polylines.count)
        for polylineIndex in 0...polylines.count - 1
        {
            let overlay = polylines[polylineIndex]
            
            let initialVertex = Vertex<ImageAnnotation>(TrailsDatabase.createAnnotation(title: overlay.title!, latitude: overlay.points()[0].coordinate.latitude, longitude: overlay.points()[0].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
            var prevVertex : Vertex<ImageAnnotation> = initialVertex
            var vertex2 : Vertex<ImageAnnotation>
            graph.addVertex(prevVertex)
            for index in 1...overlay.pointCount - 1
            {
                vertex2 = Vertex<ImageAnnotation>(TrailsDatabase.createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
                graph.addVertex(vertex2)
                var weight : Int
                switch overlay.initialAnnotation?.difficulty
                {
                case .easy:
                    weight = 1
                case .intermediate:
                    weight = 50
                case .advanced:
                    weight = 300
                case .expertsOnly:
                    weight = 4000
                case .terrainPark:
                    weight = 300
                default:
                    weight = 100
                }
                if overlay.initialAnnotation!.isConnector
                {
                    graph .addEdge(direction: .undirected, from: prevVertex, to: vertex2, weight: 1)
                }
                else
                {
                    graph.addEdge(direction: .directed, from: prevVertex, to: vertex2, weight: Double(weight))
                }
                prevVertex = vertex2
            }
//            let mapImageAnnotations = mapView.annotations.filter({$0 as? ImageAnnotation != nil}) as! [ImageAnnotation]
//            guard let annotation = mapImageAnnotations.first(where: {$0.title == overlay.title}) else
//            {
//                continue
//            }
//            graph.addVertex(Vertex<ImageAnnotation>(annotation))
//            graph.addEdge(direction: .undirected, from: Vertex<ImageAnnotation>(annotation), to: initialVertex, weight: 1)
        }
        var previousIntersectingEdges : [DirectedEdge<ImageAnnotation>] = []
        for vertex in graph.vertices
        {
            if !getIntersectingPoints(vertex: vertex).isEmpty
            {
                print("From: \(vertex.value.title!) with coordinate: \(vertex.value.coordinate)")
                for point in getIntersectingPoints(vertex: vertex)
                {
                    if previousIntersectingEdges.contains(DirectedEdge(source: point, destination: vertex, weight: 1)) || previousIntersectingEdges.contains(DirectedEdge(source: vertex, destination: point, weight: 1))
                    {
                        print("test")
                        continue
                    }
                    print("To: \(point.value.title!) with coordiante: \(vertex.value.coordinate)")
                    graph.addEdge(direction: .undirected, from: point, to: vertex, weight: 1)
                    previousIntersectingEdges.append(DirectedEdge(source: vertex, destination: point, weight: 1))
                    previousIntersectingEdges.append(DirectedEdge(source: point, destination: vertex, weight: 1))
                }
            }
        }
//        for overlay in polylines
//        {
//            let vertex = graph.vertices.first(where: {$0.value.coordinate == overlay.points()[0].coordinate})!
//            let closestVertex = getClosestPoint(vertex: vertex)
//            graph.addEdge(direction: .undirected, from: vertex, to: closestVertex, weight: 1)
//        }
        
        
//        mapView.removeOverlays(mapView.overlays)
//        mapView.removeAnnotations(mapView.annotations)
//        var myPolyLine = CustomPolyline()
//        for edge in graph.edges(){
//            myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
//            switch edge.source.value.difficulty{
//            case .easy:
//                myPolyLine.color = UIColor(red: 0.03, green: 0.25, blue: 0, alpha: 1)
//            case .intermediate:
//                myPolyLine.color = UIColor(red: 0.03, green: 0, blue: 0.5, alpha: 1)
//            case .advanced:
//                myPolyLine.color = .gray
//            case .lift:
//                myPolyLine.color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
//            case .terrainPark:
//                myPolyLine.color = .orange
//            default:
//                myPolyLine.color = .black
//            }
//            myPolyLine.initialAnnotation = edge.source.value
//            mapView.addOverlay(myPolyLine, level: .aboveRoads)
//        }
        print("Finished Graph with \(graph.verticesCount()) Vertices and \(graph.edgesCount()) Edges")
//        for overlay in mapView.overlays
//        {
//            if let overlay = overlay as? CustomPolyline
//            {
//                
//                let closestInitialVertex = graph.vertices.first(where: {$0.value.coordinate == closestAnnotation})!
//                let closestFinalVertex = graph.vertices.first(where: {$0.value.coordinate == lastClosestCoordinate})!
//                let initialVertex = graph.vertices.first(where: {$0.value.coordinate == firstCoordinate})!
//                let lastVertex = graph.vertices.first(where: {$0.value.coordinate == lastCoordinate})!
//                graph.addEdge(direction: .undirected, from: closestInitialVertex, to: initialVertex, weight: 1)
//                graph.addEdge(direction: .undirected, from: lastVertex, to: closestFinalVertex, weight: 1)
//                
//            }
//        }
//        
    }
    private func getIntersectingPoints(vertex: Vertex<ImageAnnotation>) -> [Vertex<ImageAnnotation>]
    {
        return graph.vertices.filter(({$0.value.title != vertex.value.title && $0.value.coordinate == vertex.value.coordinate}))
    }
    private func getClosestPoint(vertex: Vertex<ImageAnnotation>) -> Vertex<ImageAnnotation>
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

//let firstCoordinate = overlay.points()[0].coordinate
//                let lastCoordinate = overlay.points()[overlay.pointCount - 1].coordinate
//                var interesectingLines : [CustomPolyline] = []
//                let initialTrail = mapView.overlays.first(where: {$0.isKind(of: CustomPolyline.self) && $0 as! CustomPolyline != overlay}) as! CustomPolyline
//                var closestAnnotation = initialTrail.points()[0].coordinate
//                var lastClosestCoordinate = initialTrail.points()[initialTrail.pointCount - 1].coordinate
//                var intersectingVertexes: [Vertex<ImageAnnotation>] = []

//                for overlay2 in mapView.overlays
//                {
//                    if let overlay2 = overlay2 as? CustomPolyline, overlay2 != overlay
//                    {
//                        for index in 1...overlay2.pointCount - 1
//                        {
//                            if(sqrt(pow(overlay2.points()[index].coordinate.latitude - firstCoordinate.latitude, 2) + pow(overlay2.points()[index].coordinate.longitude - firstCoordinate.longitude, 2)) < (sqrt(pow(closestAnnotation.latitude - firstCoordinate.latitude, 2) + (pow(closestAnnotation.longitude - firstCoordinate.longitude, 2))))){
//                                closestAnnotation = overlay2.points()[index].coordinate
//                            }
//                            if(sqrt(pow(overlay2.points()[index].coordinate.latitude - lastCoordinate.latitude, 2) + pow(overlay2.points()[index].coordinate.longitude - lastCoordinate.longitude, 2)) < (sqrt(pow(lastClosestCoordinate.latitude - lastCoordinate.latitude, 2) + (pow(lastClosestCoordinate.longitude - lastCoordinate.longitude, 2))))){
//                                lastClosestCoordinate = overlay2.points()[index].coordinate
//                            }
//                        }
//                        if overlay.intersects(overlay2.boundingMapRect)
//                        {
//                            interesectingLines.append(overlay2)
//                        }
//                    }
//                }
//
