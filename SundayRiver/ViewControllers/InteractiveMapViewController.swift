//
//  InteractiveMapViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/25/22.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class InteractiveMapViewController: UIViewController, CLLocationManagerDelegate
{
    static var currentUser = User(userName: "Guest", password: "")
    var myMap = MKMapView()
    var tileRenderer: MKTileOverlayRenderer!
    var myPolyLine = CustomPolyline()
    
    static var routeInProgress = false
    
    var easyLabel = UILabel()
    var intermediateLabel = UILabel()
    var advancedLabel = UILabel()
    var expertsOnlyLabel = UILabel()
    var liftLabel = UILabel()
    
    var settingArray = ["Moguls","Icy","Crowded","Cancel"]
    var trailReportMenu : PopUpMenuFramework?
    var trailReportTableView = UITableView()
    
    let locationManager = CLLocationManager()
    
    var origin = ImageAnnotation()
    
    var routeOverviewMenu : PopUpMenuFramework?
    var routeOverviewView : RouteOverviewView?
    
    var trailReportAnnotation = ImageAnnotation()
    
    var originVertex : Vertex<ImageAnnotation>?
    static var destination : Trail?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        TrailsDatabase.addVertexes()
        TrailsDatabase.createEdges()
        configureMyMap()
        //        configureKey()
        configureTrailReportView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        self.tabBarController?.tabBar.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        if InteractiveMapViewController.destination != nil {
            createRoute()
        }
        else {
            showTrails()
        }
    }
    
    private func configureTrailReportView()
    {
        trailReportTableView.isScrollEnabled = true
        trailReportTableView.layer.cornerRadius = 15
        trailReportTableView.delegate = self
        trailReportTableView.dataSource = self
        trailReportTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    private func configureKey()
    {
        let preferredFont = UIFont.systemFont(ofSize: 15)
        easyLabel.text = "Easier Trails: 🟢"
        easyLabel.textColor = .green
        easyLabel.translatesAutoresizingMaskIntoConstraints = false
        easyLabel.font = preferredFont
        
        intermediateLabel.text = "Intermediate Trails: 🟦"
        intermediateLabel.textColor = .blue
        intermediateLabel.translatesAutoresizingMaskIntoConstraints = false
        intermediateLabel.font = preferredFont
        
        advancedLabel.text = "Advanced Trails: ♢"
        advancedLabel.textColor = .black
        advancedLabel.translatesAutoresizingMaskIntoConstraints = false
        advancedLabel.font = preferredFont
        
        expertsOnlyLabel.text = "Experts Only Trails: ♢♢"
        expertsOnlyLabel.textColor = .red
        expertsOnlyLabel.translatesAutoresizingMaskIntoConstraints = false
        expertsOnlyLabel.font = preferredFont
        
        liftLabel.text = "Lifts: -"
        liftLabel.textColor = .purple
        liftLabel.translatesAutoresizingMaskIntoConstraints = false
        liftLabel.font = preferredFont
        
        
        self.view.addSubview(easyLabel)
        self.view.addSubview(intermediateLabel)
        self.view.addSubview(advancedLabel)
        self.view.addSubview(expertsOnlyLabel)
        self.view.addSubview(liftLabel)
        
        createConstraints(item: easyLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 20 )
        createConstraints(item: intermediateLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 10  )
        createConstraints(item: advancedLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) * 3 / 20)
        createConstraints(item: expertsOnlyLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 5)
        createConstraints(item: liftLabel, distFromLeft: Double(view.bounds.width)/2, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 4)
    }
    
    private func configureMyMap()
    {
        //        setupTileRenderer()
        myMap.mapType = MKMapType.hybridFlyover
        //        myMap.mapType = MKMapType.satellite
        //        myMap.mapType = MKMapType.satelliteFlyover
        
        myMap.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        myMap.isZoomEnabled = true
        myMap.isScrollEnabled = true
        
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 44.46806937533083, longitude: -70.87985973100996),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
        
        myMap.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 1550,
            maxCenterCoordinateDistance: 12500)
        myMap.cameraBoundary = MKMapView.CameraBoundary(
            coordinateRegion: initialRegion)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPress.minimumPressDuration = 0.3
        
        myMap.addGestureRecognizer(longPress)
        myMap.region = initialRegion
        myMap.showsUserLocation = true
        myMap.showsCompass = true
        myMap.setUserTrackingMode(.followWithHeading, animated: true)
        myMap.delegate = self
        myMap.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        myMap.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        createKeyTrailAnnotation()
        view.addSubview(myMap)
    }
    
    
    private func setupTileRenderer() {
        let overlay = MapOverlay()
        overlay.canReplaceMapContent = true
        myMap.addOverlay(overlay, level: .aboveRoads)
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
        overlay.minimumZ = 13
        overlay.maximumZ = 17
    }
    
    func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    private func getClosestAnnotation(origin: ImageAnnotation) -> Vertex<ImageAnnotation>
    {
        var nearestAnnotation = TrailsDatabase.annotations[0]
        for annotation in TrailsDatabase.annotations
        {
            
            if(sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < (sqrt(pow(nearestAnnotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + (pow(nearestAnnotation.value.coordinate.longitude - origin.coordinate.longitude, 2))))){
                nearestAnnotation = annotation
            }
        }
        return nearestAnnotation
    }
    
    private func assignOrigin()
    {
        guard let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude else{
            return
        }
        origin = TrailsDatabase.createAnnotation(title: "origin", latitude: latitude, longitude: longitude, difficulty: .easy)
        originVertex = Vertex<ImageAnnotation>(origin)
        TrailsDatabase.graph.addVertex(originVertex!)
        TrailsDatabase.graph.addEdge(direction: .directed, from: originVertex!, to: getClosestAnnotation(origin: origin), weight: 1)
    }
    
    func createRoute()
    {
        for overlay in myMap.overlays(in: .aboveRoads){
            myMap.removeOverlay(overlay)
        }
        assignOrigin()
        
        let destinationTrail = InteractiveMapViewController.destination!
        var destinationAnnotation = destinationTrail.annotations[0]
        var destinationVertex : Vertex<ImageAnnotation> = TrailsDatabase.annotations[0]
        
        for trailName in TrailsDatabase.CommonlyJunctionedTrailNames
        {
            if trailName == destinationTrail.name
            {
                if trailName == "Northern Lights"
                {
                    destinationAnnotation = destinationTrail.annotations[2]
                }
                else if trailName == "Dream Maker"
                {
                    destinationAnnotation = destinationTrail.annotations[3]
                }
                else
                {
                    destinationAnnotation = destinationTrail.annotations[1]
                }
                break
            }
        }
        for vertex in TrailsDatabase.annotations
        {
            if vertex.value.coordinate.latitude == destinationAnnotation.coordinate.latitude && vertex.value.coordinate.longitude == destinationAnnotation.coordinate.longitude
            {
                destinationVertex = vertex
            }
        }
        if let pathToDestination = DijkstraShortestPath(TrailsDatabase.graph, source: originVertex!).pathTo(destinationVertex){
            var previousEdge = pathToDestination[0]
            var description = ""
            var trailReports = ""
            for edge in pathToDestination{
                if(previousEdge.value.difficulty == .easy)
                {
                    myPolyLine = CustomPolyline(coordinates: [previousEdge.value.coordinate, edge.value.coordinate], count: 2)
                    myPolyLine.color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
                }
                else if (previousEdge.value.difficulty == .intermediate)
                {
                    myPolyLine = CustomPolyline(coordinates: [previousEdge.value.coordinate, edge.value.coordinate], count: 2)
                    myPolyLine.color = .blue
                }
                else if (previousEdge.value.difficulty == .advanced)
                {
                    myPolyLine = CustomPolyline(coordinates: [previousEdge.value.coordinate, edge.value.coordinate], count: 2)
                    myPolyLine.color = .black
                }
                else if (previousEdge.value.difficulty == .lift)
                {
                    myPolyLine = CustomPolyline(coordinates: [previousEdge.value.coordinate, edge.value.coordinate], count: 2)
                    myPolyLine.color = .purple
                }
                else if (previousEdge.value.difficulty == .terrainPark)
                {
                    myPolyLine = CustomPolyline(coordinates: [previousEdge.value.coordinate, edge.value.coordinate], count: 2)
                    myPolyLine.color = .orange
                }
                else
                {
                    myPolyLine = CustomPolyline(coordinates: [previousEdge.value.coordinate, edge.value.coordinate], count: 2)
                    myPolyLine.color = .red
                }
                myMap.addOverlay(myPolyLine, level: .aboveRoads)
                for annotation in TrailsDatabase.keyAnnotations
                {
                    myMap.removeAnnotation(annotation.value)
                }
                for annotation in TrailsDatabase.keyAnnotations
                {
                    if (annotation.value == edge.value) && (!description.contains(annotation.value.title!))
                    {
                        myMap.addAnnotation(annotation.value)
                        description.append("\(edge.value.title!); ")
                    }
                }
                previousEdge = edge
                if let trailReport = (edge.value.trailReport)
                {
                    trailReports.append("\(trailReport.subtitle!) ")
                }
            }
            if(!InteractiveMapViewController.routeInProgress)
            {
                routeOverviewView = RouteOverviewView(frame: self.view.frame)
                
                let index = description.index(description.startIndex, offsetBy: description.count - 2)
                description = String(description.prefix(upTo: index))
                routeOverviewView?.directionsTextView.text = "\(description)"
                
                routeOverviewView?.tripLbl.text = "Your Location -> \(destinationTrail.name)"
                
                routeOverviewView?.trailReportTextView.text = trailReports
                
                routeOverviewView?.configureItems()
                presentRouteOverviewMenu()
                InteractiveMapViewController.routeInProgress = true
            }
            
        }
    }
    
    private func showTrails()
    {
        for edge in TrailsDatabase.graph.edges(){
            if(edge.source.value.difficulty == .easy)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
            }
            else if (edge.source.value.difficulty == .intermediate)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = .blue
            }
            else if (edge.source.value.difficulty == .advanced)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = .black
            }
            else if (edge.source.value.difficulty == .lift)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = .purple
                
            }
            else if (edge.source.value.difficulty == .terrainPark)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = .orange
            }
            else
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = .red
            }
            myMap.addOverlay(myPolyLine, level: .aboveRoads)
        }
    }
    
    @objc func addAnnotation(gesture: UIGestureRecognizer) {
        
        if gesture.state == .ended {
            
            if let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                self.trailReportAnnotation = ImageAnnotation()
                self.trailReportAnnotation.coordinate = coordinate
                presentTrailReportMenu()
                InteractiveMapViewController.routeInProgress = true
            }
        }
    }
    
    private func presentTrailReportMenu()
    {
        trailReportTableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 250)
        let window = UIApplication.shared.keyWindow
        trailReportMenu = PopUpMenuFramework(viewController: self, window: window!, screenSize: UIScreen.main.bounds.size, transparentView: UIView(frame: self.view.frame), height: 250)
        trailReportMenu?.view = trailReportTableView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        trailReportMenu?.transparentView.addGestureRecognizer(dismissTapGesture)
        trailReportMenu?.presentItems()
    }
    func createKeyTrailAnnotation()
    {
        for annotation in TrailsDatabase.keyAnnotations
        {
            myMap.addAnnotation(annotation.value)
        }
    }
    @objc func dismissMenu() {
        trailReportMenu!.dismissItems()
    }

    
    private func presentRouteOverviewMenu()
    {
        routeOverviewView!.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200)
        let window = UIApplication.shared.keyWindow
        routeOverviewMenu = PopUpMenuFramework(viewController: self, window: window!, screenSize: UIScreen.main.bounds.size, transparentView: UIView(frame: self.view.frame), height: 200)
        routeOverviewMenu?.view = routeOverviewView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissRouteOverviewMenu))
        routeOverviewMenu?.transparentView.addGestureRecognizer(dismissTapGesture)
        routeOverviewView?.letsGoButton.addTarget(self, action: #selector(dismissRouteOverviewMenu), for: .touchUpInside)
        routeOverviewMenu?.presentItems()
    }
    
    @objc func dismissRouteOverviewMenu() {
        self.routeOverviewMenu?.dismissItems()
    }
    
    func createTrailReport(type: TrailReportType)
    {
        dismissMenu()
        let originAnnotation = TrailsDatabase.createAnnotation(title: "", latitude: self.trailReportAnnotation.coordinate.latitude, longitude: self.trailReportAnnotation.coordinate.longitude, difficulty: .easy)
        let trail = getClosestAnnotation(origin: originAnnotation).value
        switch type
        {
        case .moguls:
            originAnnotation.subtitle = "Moguls"
        case .ice:
            originAnnotation.subtitle = "Icy"
        case .crowded:
            originAnnotation.subtitle = "Crowded"
            
        }
        trail.trailReport = originAnnotation
        myMap.addAnnotation(originAnnotation)
        
    }
    
}

extension InteractiveMapViewController: MKMapViewDelegate
{
    func mapView(
      _ mapView: MKMapView,
      rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        if overlay.isKind(of: CustomPolyline.self)
        {
            let polyLine = overlay as! CustomPolyline
            let polylineRenderer = MKPolylineRenderer(overlay: polyLine)
            polylineRenderer.strokeColor = polyLine.color!
            polylineRenderer.lineWidth = 2.0
            
            return polylineRenderer
        }
        return tileRenderer
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is ClusterAnnotationView else { return }
        print("test")
        // if the user taps a cluster, zoom in
        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2.0, longitudeDelta: currentSpan.longitudeDelta / 2.0)
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
    }
}

extension InteractiveMapViewController: UITableViewDataSource, UITableViewDelegate {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return settingArray.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomTableViewCell else {fatalError("Unable to deque cell")}
         cell.lbl.text = settingArray[indexPath.row]
         if(settingArray[indexPath.row] == "Moguls")
         {
             cell.settingImage.image = UIImage(named: "MogulSquare.png")!
         }
         else if (settingArray[indexPath.row] == "Icy")
         {
             cell.settingImage.image = UIImage(named: "IcySquare.png")!
         }
         return cell
     }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select A Trail Report"
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 50
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        if (cell.lbl.text == "Moguls")
        {
            createTrailReport(type: .moguls)
        }
        else if(cell.lbl.text == "Icy")
        {
            createTrailReport(type: .ice)
        }
        else if (cell.lbl.text == "Crowded")
        {
            createTrailReport(type: .crowded)
        }
        else if(cell.lbl.text == "Cancel")
        {
            dismissMenu()
        }
    }
 }
