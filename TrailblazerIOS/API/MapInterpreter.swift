import Foundation
import MapKit

final class MapInterpreter: NSObject {
    static let shared = MapInterpreter()
    var mapView = MKMapView()
    let baseURL = getBaseUrl()
    static var map : Map?
    var difficultyGraph = EdgeWeightedDigraph<ImageAnnotation>()
    var timeGraph = EdgeWeightedDigraph<ImageAnnotation>()
    var distanceGraph = EdgeWeightedDigraph<ImageAnnotation>()
    
    var baseLiftVertexes = [Vertex<ImageAnnotation>]()
    func getMap(id: String)
    {
        //        if let map = UserDefaults.standard.array(forKey: id) as? [CustomPolyline], let distanceGraph = UserDefaults.standard.value(forKey: "\(id)/distanceGraph") as? EdgeWeightedDigraph<ImageAnnotation>, let difficultyGraph = UserDefaults.standard.value(forKey: "\(id)/difficultyGraph") as? EdgeWeightedDigraph<ImageAnnotation>
        //        {
        //            self.mapView.addOverlays(map)
        //            self.distanceGraph = distanceGraph
        //            self.difficultyGraph = difficultyGraph
        //            DispatchQueue.global().async{
        //                self.getTrailReportsFromDB()
        //            }
        //            return
        //        }
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
                Self.map = try decoder.decode(Map.self, from: data)
                print("test map")
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
                Self.map?.mapTrail = try decoder.decode([MapTrail].self, from: data)
                if Self.map?.mapTrail != nil
                {
                    var collectedIndex = 0
                    for index in 0...Self.map!.mapTrail!.count - 1
                    {
                        self.getPoints(id: Self.map!.mapTrail![index].id!, isConnector: false, completion: { result in
                            guard let points = try? result.get() else
                            {
                                print("Error: \(result)")
                                return
                            }
                            Self.map!.mapTrail![index].points = points
                            collectedIndex += 1
                            if collectedIndex == Self.map!.mapTrail!.count
                            {
                                self.getMapConnectors(id: id, completion: {
                                    result in
                                    guard (try? result.get()) != nil else
                                    {
                                        print("Error: \(result)")
                                        return
                                    }
                                    print("testMap")
                                    self.createMap(map: Self.map!)
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
                Self.map?.mapConnector = try decoder.decode([MapConnector].self, from: data)
                if Self.map?.mapConnector != nil
                {
                    var collectedIndex = 0
                    for index in 0..<Self.map!.mapConnector!.count
                    {
                        self.getPoints(id: Self.map!.mapConnector![index].id!, isConnector: true, completion: { result in
                            guard let points = try? result.get() else
                            {
                                print("Error: \(result)")
                                return
                            }
                            collectedIndex += 1
                            Self.map!.mapConnector![index].points = points
                            //print(collectedIndex)
                            if collectedIndex == Self.map!.mapConnector!.count
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
                    completion(.success(points.sorted(by: { $0.order < $1.order })))
                }
            } catch {
                print("Unable to parse JSON response.")
                completion(.failure(error))
            }
            
        }.resume()
    }
    private func createMap(map: Map)
    {
        var polylines: [CustomPolyline] = []
        for trail in map.mapTrail!
        {
            var coordinates : [CLLocationCoordinate2D] = []
            guard let points = trail.points else {
                print("Points do not exist")
                return
            }
            var trailTimes : [[Double]] = []
            var pointIds: [String] = []
            
            var difficulty : Difficulty = .expertsOnly
            var color = UIColor.myTheme.expertsOnlyColor
            switch trail.difficulty
            {
            case Difficulty.easy.rawValue:
                difficulty = .easy
                color = .myTheme.easyColor
            case Difficulty.intermediate.rawValue:
                difficulty = .intermediate
                color = .myTheme.intermediateColor
            case Difficulty.advanced.rawValue:
                difficulty = .advanced
                color = .myTheme.advancedColor
            case Difficulty.lift.rawValue:
                difficulty = .lift
                color = .myTheme.liftsColor
            case Difficulty.terrainPark.rawValue:
                difficulty = .terrainPark
                color = .myTheme.terrainParksColor
            default:
                break
            }
            for point in points
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
        for connector in map.mapConnector!
        {
            var coordinates : [CLLocationCoordinate2D] = []
            guard let points = connector.points else {
                print("Map Connector Points Don't Exist")
                return
            }
            var trailTimes : [[Double]] = []
            var pointIds: [String] = []
            for point in points
            {
                coordinates.append(CLLocationCoordinate2D(latitude: Double(point.latitude), longitude: Double(point.longitude)))
                pointIds.append(point.id!)
                trailTimes.append(point.time as! [Double])
            }
            let polyline = CustomPolyline(coordinates: coordinates, count: coordinates.count)
            polyline.title = connector.name
            let initialAnnotation = createAnnotation(title: connector.name, latitude: coordinates[0].latitude, longitude: coordinates[0].longitude, difficulty: .easy)
            initialAnnotation.isConnector = true
            initialAnnotation.trailTimes = trailTimes
            polyline.color = UIColor(hex: "#00be00ff")
            polyline.initialAnnotation = initialAnnotation
            initialAnnotation.ids = pointIds
            polylines.append(polyline)
        }
        mapView.removeOverlays(mapView.overlays)
        self.difficultyGraph = EdgeWeightedDigraph<ImageAnnotation>()
        self.timeGraph = EdgeWeightedDigraph<ImageAnnotation>()
        self.distanceGraph = EdgeWeightedDigraph<ImageAnnotation>()
        mapView.addOverlays(polylines)
        DispatchQueue.global().async{
            self.createDifficultyGraph()
            self.createDistanceGraph()
            self.createTimeGraph()
            self.getTrailReportsFromDB()
            //            UserDefaults.standard.set(self.difficultyGraph, forKey: "\(self.map?.id)/difficultyGraph")
            //            UserDefaults.standard.set(self.distanceGraph, forKey: "\(self.map?.id)/distanceGraph")
        }
    }
    private func createDifficultyGraph()
    {
        //print("test Graph")
        let polylines = mapView.overlays.filter({$0 as? CustomPolyline != nil}) as! [CustomPolyline]
        var foundTrails : [String] = []
        //print(polylines.count)
        for polylineIndex in 0...polylines.count - 1
        {
            let overlay = polylines[polylineIndex]
            let initialVertex = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[0].coordinate.latitude, longitude: overlay.points()[0].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
            if !foundTrails.contains(overlay.title!)
            {
                mapView.addAnnotation(initialVertex.value)
                foundTrails.append(overlay.title!)
            }
            if initialVertex.value.difficulty == Difficulty.lift
            {
                self.baseLiftVertexes.append(initialVertex)
            }
            var prevVertex : Vertex<ImageAnnotation> = initialVertex
            prevVertex.value.id = overlay.initialAnnotation?.ids![0]
            prevVertex.value.times = overlay.initialAnnotation?.trailTimes![0]
            var vertex2 : Vertex<ImageAnnotation>
            difficultyGraph.addVertex(prevVertex)
            for index in 1...overlay.pointCount - 1
            {
                vertex2 = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
                difficultyGraph.addVertex(vertex2)
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
                vertex2.value.id = overlay.initialAnnotation?.ids![index]
                vertex2.value.times = overlay.initialAnnotation?.trailTimes![index]
                if overlay.initialAnnotation!.isConnector
                {
                    prevVertex.value.isConnector = true
                    vertex2.value.isConnector = true
                    difficultyGraph .addEdge(direction: .undirected, from: prevVertex, to: vertex2, weight: 1)
                }
                else
                {
                    difficultyGraph.addEdge(direction: .directed, from: prevVertex, to: vertex2, weight: Double(weight))
                }
                prevVertex = vertex2
            }
        }
        addIntersectingPointsTo(graph: difficultyGraph)
        print("Finished Difficulty Graph with \(difficultyGraph.verticesCount()) Vertices and \(difficultyGraph.edgesCount()) Edges")
    }
    
    private func createDistanceGraph()
    {
        let polylines = mapView.overlays.filter({$0 as? CustomPolyline != nil}) as! [CustomPolyline]
        //print(polylines.count)
        for polylineIndex in 0...polylines.count - 1
        {
            let overlay = polylines[polylineIndex]
            let initialVertex = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[0].coordinate.latitude, longitude: overlay.points()[0].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
            var prevVertex : Vertex<ImageAnnotation> = initialVertex
            prevVertex.value.id = overlay.initialAnnotation?.ids![0]
            prevVertex.value.times = overlay.initialAnnotation?.trailTimes![0]
            var vertex2 : Vertex<ImageAnnotation>
            distanceGraph.addVertex(prevVertex)
            for index in 1...overlay.pointCount - 1
            {
                vertex2 = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
                distanceGraph.addVertex(vertex2)
                let weight = CLLocation(latitude: prevVertex.value.coordinate.latitude, longitude: prevVertex.value.coordinate.longitude).distance(from: CLLocation(latitude: vertex2.value.coordinate.latitude, longitude: vertex2.value.coordinate.longitude))
                vertex2.value.id = overlay.initialAnnotation?.ids![index]
                vertex2.value.times = overlay.initialAnnotation?.trailTimes![index]
                if overlay.initialAnnotation!.isConnector
                {
                    prevVertex.value.isConnector = true
                    vertex2.value.isConnector = true
                    distanceGraph.addEdge(direction: .undirected, from: prevVertex, to: vertex2, weight: weight)
                }
                else
                {
                    distanceGraph.addEdge(direction: .directed, from: prevVertex, to: vertex2, weight: weight)
                }
                prevVertex = vertex2
            }
        }
        addIntersectingPointsTo(graph: distanceGraph)
        print("Completed Distance Graph with \(distanceGraph.verticesCount()) vertices and  \(distanceGraph.edgesCount()) edges!")
    }
    
    private func createTimeGraph()
    {
        let polylines = mapView.overlays.filter({$0 as? CustomPolyline != nil}) as! [CustomPolyline]
        //print(polylines.count)
        for polylineIndex in 0...polylines.count - 1
        {
            let overlay = polylines[polylineIndex]
            let initialVertex = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[0].coordinate.latitude, longitude: overlay.points()[0].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
            var prevVertex : Vertex<ImageAnnotation> = initialVertex
            prevVertex.value.id = overlay.initialAnnotation?.ids![0]
            prevVertex.value.times = overlay.initialAnnotation?.trailTimes![0]
            var vertex2 : Vertex<ImageAnnotation>
            timeGraph.addVertex(prevVertex)
            for index in 1...overlay.pointCount - 1
            {
                vertex2 = Vertex<ImageAnnotation>(createAnnotation(title: overlay.title!, latitude: overlay.points()[index].coordinate.latitude, longitude: overlay.points()[index].coordinate.longitude, difficulty: overlay.initialAnnotation!.difficulty!))
                timeGraph.addVertex(vertex2)
                
                let weightArray = overlay.initialAnnotation!.trailTimes![index]
                let weight = weightArray.reduce(0.0, +) / Double(weightArray.count)
                
                vertex2.value.id = overlay.initialAnnotation?.ids![index]
                vertex2.value.times = overlay.initialAnnotation?.trailTimes![index]
                if overlay.initialAnnotation!.isConnector
                {
                    prevVertex.value.isConnector = true
                    vertex2.value.isConnector = true
                    timeGraph.addEdge(direction: .undirected, from: prevVertex, to: vertex2, weight: weight)
                }
                else
                {
                    timeGraph.addEdge(direction: .directed, from: prevVertex, to: vertex2, weight: weight)
                }
                prevVertex = vertex2
            }
        }
        addIntersectingPointsTo(graph: timeGraph)
        print("Completed Distance Graph with \(timeGraph.verticesCount()) vertices and  \(timeGraph.edgesCount()) edges!")
    }
    
    private func addIntersectingPointsTo(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        var previousIntersectingEdges : [DirectedEdge<ImageAnnotation>] = []
        for vertex in graph.vertices
        {
            if !getIntersectingPoints(graph: graph, vertex: vertex).isEmpty
            {
                //print("From: \(vertex.value.title!) with coordinate: \(vertex.value.coordinate)")
                for point in getIntersectingPoints(graph: graph, vertex: vertex)
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
    private func getTrailReportsFromDB()
    {
        getTrailReports(completion: { [self] value in
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
                var closestTrail = getClosestAnnotation(graph: distanceGraph, origin: annotation).value
                closestTrail.trailReport = annotation
                closestTrail = getClosestAnnotation(graph: difficultyGraph, origin: annotation).value
                closestTrail.trailReport = annotation
                closestTrail = getClosestAnnotation(graph: timeGraph, origin: annotation).value
                closestTrail.trailReport = annotation
                mapView.addAnnotation(annotation)
                guard InteractiveMapViewController.currentUser.alertSettings.contains(report.type) else { continue }
                NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": report])
            }
            NotificationCenter.default.post(name: Notification.Name("configureTrailSelector"), object: nil)
            NotificationCenter.default.post(Notification(name: Notification.Name("updateInitialRegion"), userInfo: ["initialRegionLatitude": Double(Self.map!.initialLocationLatitude!), "initialRegionLongitude": Double(Self.map!.initialLocationLongitude!), "trailReports": trailReports]))
            
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
