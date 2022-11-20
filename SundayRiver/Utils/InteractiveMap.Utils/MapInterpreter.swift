import Foundation
import MapKit

struct Map : Codable, Equatable
{
    var id: String?
    var name: String?
    var mapTrail: [MapTrail]?
    
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
    
    public static func == (lhs: MapTrail, rhs: MapTrail) -> Bool
    {
        return lhs.id == rhs.id
    }
}
struct Point: Codable {
    var id: String?
    var mapTrailId: MapTrail?
    var latitude: Float
    var longitude: Float
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
                    for index in 0...self.map!.mapTrail!.count - 1
                    {
                        print(index)
                        self.getPoints(id: self.map!.mapTrail![index].id!, completion: { result in
                            guard let points = try? result.get() else
                            {
                                print("Error: \(result)")
                                return
                            }
                            self.map!.mapTrail![index].points = points
                            if index == self.map!.mapTrail!.count - 1
                            {
                                self.createMap(map: self.map!)
                            }
                        })
                    }
                }
            } catch {
                print("Error decoding map trails: \(error)")
            }
        }.resume()
    }
    private func getPoints(id: String, completion: @escaping (Result<[Point], Error>) -> Void)
    {
        let url = URL(string: "\(baseURL)/api/map-trails/\(id)/points")!
        
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
        guard let trails = map.mapTrail else { return }
        for trail in trails
        {
            var coordinates : [CLLocationCoordinate2D] = []
            guard let points = trail.points else { return }
            for index in 0...points.count - 1
            {
                let lat = points[index].longitude
                let long = points[index].latitude
                coordinates.append(CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long)))
            }

            let polyline = CustomPolyline(coordinates: coordinates, count: points.count)
            polyline.title = trail.name
            polyline.initialAnnotation = TrailsDatabase.createAnnotation(title: trail.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: .easy)
            polylines.append(polyline)
            annotations.append(polyline.initialAnnotation!)
        }
        print("test")
        mapView.addOverlays(polylines)
        mapView.addAnnotations(annotations)
        createGraph()
    }
    private func createGraph()
    {
        for overlay in mapView.overlays
        {
            if let overlay = overlay as? CustomPolyline
            {
                var vertex1 : Vertex<ImageAnnotation>
                var vertex2 : Vertex<ImageAnnotation>
                for index in 1...overlay.pointCount - 1
                {
                    vertex1 = Vertex<ImageAnnotation>(TrailsDatabase.createAnnotation(title: overlay.title!, latitude: overlay.points()[index - 1].coordinate.latitude, longitude: overlay.points()[index - 1].coordinate.longitude, difficulty: .easy))
                    vertex2 = Vertex<ImageAnnotation>(TrailsDatabase.createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: .easy))
                    
                    graph.addVertex(vertex1)
                    graph.addVertex(vertex2)
                    graph.addEdge(direction: .directed, from: vertex1, to: vertex2, weight: 1)
                }
            }
        }
        for vertex in graph.vertices
        {
            if !getIntersectingPoints(vertex: vertex).isEmpty
            {
                for point in getIntersectingPoints(vertex: vertex)
                {
                    graph.addEdge(direction: .undirected, from: vertex, to: point, weight: 1)
                }
            }
            else
            {
                
            }
        }
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
        return graph.vertices.filter(({$0.value.coordinate == vertex.value.coordinate}))
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