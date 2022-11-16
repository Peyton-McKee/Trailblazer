import Foundation
import MapKit

struct Map : Codable
{
    var name: String
    var trails: [MapTrail]
}

struct MapTrail: Codable {
    var name: String
    var latitudes: [Double]
    var longitudes: [Double]
}

final class MapInterpreter: NSObject {
    static let shared = MapInterpreter()
    var mapView = MKMapView()
    let baseURL = "http://35.172.135.117"
    var graph = EdgeWeightedDigraph<ImageAnnotation>()
    override init() {
        super.init()
        
    }
    func downloadTrails(id: String)
    {
        let url = URL(string: "\(baseURL)/api/maps/\(id)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error with fetching trails: \(error)")
                return
            }
            guard let data = data else {
                print("No data returned from data task")
                return
            }
            do {
                let decoder = JSONDecoder()
                let map = try decoder.decode(Map.self, from: data)
                self.createMap(map: map)
            } catch {
                print("Error decoding trails: \(error)")
            }
        }.resume()
    }
    func createMap(map: Map)
    {
        var annotations : [ImageAnnotation] = []
        var polylines: [CustomPolyline] = []
        for trail in map.trails
        {
            var coordinates : [CLLocationCoordinate2D] = []
            for index in 0...trail.latitudes.count
            {
                let lat = trail.latitudes[index]
                let long = trail.longitudes[index]
                coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
            }
            
            let polyline = CustomPolyline(coordinates: coordinates, count: trail.latitudes.count)
            polyline.title = trail.name
            polyline.initialAnnotation = TrailsDatabase.createAnnotation(title: trail.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: .easy)
            polylines.append(polyline)
            annotations.append(polyline.initialAnnotation!)
        }
        mapView.addOverlays(polylines)
        mapView.addAnnotations(annotations)
        createGraph()
    }
    func createGraph()
    {
        for overlay in mapView.overlays
        {
            if let overlay = overlay as? CustomPolyline
            {
                var vertex1 : Vertex<ImageAnnotation>
                var vertex2 : Vertex<ImageAnnotation>
                for index in 1...overlay.pointCount
                {
                    vertex1 = Vertex<ImageAnnotation>(TrailsDatabase.createAnnotation(title: overlay.title!, latitude: overlay.points()[index - 1].coordinate.latitude, longitude: overlay.points()[index - 1].coordinate.longitude, difficulty: .easy))
                    vertex2 = Vertex<ImageAnnotation>(TrailsDatabase.createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: .easy))
                    graph.addVertex(vertex1)
                    graph.addVertex(vertex2)
                    graph.addEdge(direction: .directed, from: vertex1, to: vertex2, weight: 1)
                }
            }
        }
        for overlay in mapView.overlays
        {
            if let overlay = overlay as? CustomPolyline
            {
                let firstCoordinate = overlay.points()[0].coordinate
                let lastCoordinate = overlay.points()[overlay.pointCount].coordinate
                
                var interesectingLines : [CustomPolyline?] = []
                
                let initialTrail = mapView.overlays.first(where: {$0.isKind(of: CustomPolyline.self) && $0 as! CustomPolyline != overlay}) as! CustomPolyline
                var closestAnnotation = initialTrail.points()[0].coordinate
                var lastClosestCoordinate = initialTrail.points()[initialTrail.pointCount].coordinate
                for overlay2 in mapView.overlays
                {
                    if let overlay2 = overlay2 as? CustomPolyline, overlay2 != overlay
                    {
                        for index in 1...overlay2.pointCount
                        {
                            if(sqrt(pow(overlay2.points()[index].coordinate.latitude - firstCoordinate.latitude, 2) + pow(overlay2.points()[index].coordinate.longitude - firstCoordinate.longitude, 2)) < (sqrt(pow(closestAnnotation.latitude - firstCoordinate.latitude, 2) + (pow(closestAnnotation.longitude - firstCoordinate.longitude, 2))))){
                                closestAnnotation = overlay2.points()[index].coordinate
                            }
                            if(sqrt(pow(overlay2.points()[index].coordinate.latitude - lastCoordinate.latitude, 2) + pow(overlay2.points()[index].coordinate.longitude - lastCoordinate.longitude, 2)) < (sqrt(pow(lastClosestCoordinate.latitude - lastCoordinate.latitude, 2) + (pow(lastClosestCoordinate.longitude - lastCoordinate.longitude, 2))))){
                                lastClosestCoordinate = overlay2.points()[index].coordinate
                            }
                        }
                        if overlay.intersects(overlay2.boundingMapRect)
                        {
                            interesectingLines.append(overlay2)
                        }
                    }
                }
                let closestInitialVertex = graph.vertices.first(where: {$0.value.coordinate == closestAnnotation})!
                let closestFinalVertex = graph.vertices.first(where: {$0.value.coordinate == lastClosestCoordinate})!
                let initialVertex = graph.vertices.first(where: {$0.value.coordinate == firstCoordinate})!
                let lastVertex = graph.vertices.first(where: {$0.value.coordinate == lastCoordinate})!
                
                graph.addEdge(direction: .undirected, from: closestInitialVertex, to: initialVertex, weight: 1)
                graph.addEdge(direction: .undirected, from: lastVertex, to: closestFinalVertex, weight: 1)
                
                print(interesectingLines)
            }
        }
    }
}

extension CLLocationCoordinate2D: Equatable
{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool
    {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
