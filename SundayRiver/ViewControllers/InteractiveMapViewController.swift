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

class InteractiveMapViewController: UIViewController
{
    static var currentUser : User?
    static var routeInProgress = false
    static var destination : ImageAnnotation?
    static var configuredClasses = false
    static var wasCancelled = false
    static var container = Container()
    static var origin : ImageAnnotation?
    static var selectedGraph = TrailsDatabase.graph
    
    var canFindPathAgain = true
    var isRealTimeGraph = false
    var toggleGraphButton = UIButton()
    var followingRoute = false
    
    let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.46806937533083, longitude: -70.87985973100996),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
    var myMap = MKMapView()
    var tileRenderer: MKTileOverlayRenderer!
    var myPolyLine = CustomPolyline()
    
    var cancelButton = UIButton()
    var cancelButtonYContraint = NSLayoutConstraint()
    var searchBar = SearchBarTableHeaderView()
    var pathCreated: [Vertex<ImageAnnotation>]?
    //    var easyLabel = UILabel()
    //    var intermediateLabel = UILabel()
    //    var advancedLabel = UILabel()
    //    var expertsOnlyLabel = UILabel()
    //    var liftLabel = UILabel()
    
    var settingArray = ["Moguls","Icy","Crowded","Cancel"]
    var trailReportMenu : PopUpMenuFramework?
    var trailReportTableView = UITableView()
    
    let locationManager = CLLocationManager()
    
    var routeOverviewMenu : PopUpMenuFramework?
    var routeOverviewView : RouteOverviewView?
    
    var trailReportAnnotation = ImageAnnotation()
    
    var originVertex : Vertex<ImageAnnotation>?
    var closestAnnotation: Vertex<ImageAnnotation>?
    
    var trailSelectorView : TrailSelectorView?
    var trailSelectorMenu : SideMenuFramework?
    
    var webAnalysis = WebAnalysis()
    
    var totalDirections : String?
    
    var recenterButton = UIButton()
    var recenterButtonYConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTrailReportView()
        configureClasses()
        configureMyMap()
        configureSearchBar()
        checkUserDefaults()
        configureTrailSelectorView()
        configureButtons()
        //        configureKey()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        getTrailReportsFromDB()
        webAnalysis.makeRequest()
        self.tabBarController?.tabBar.backgroundColor = .black
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedTrail), name: Notification.Name(rawValue: "selectedTrail"), object: InteractiveMapViewController.container)
        NotificationCenter.default.addObserver(self, selector: #selector(selectGraph), name: Notification.Name(rawValue: "selectGraph"), object: nil)
        if InteractiveMapViewController.destination != nil {
            sampleRoute()
        }
        else {
            showAllTrails()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.trailSelectorView as Any, name: Notification.Name(rawValue: "searchTrail"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedTrail"), object: Self.container)
        NotificationCenter.default.addObserver(self, selector: #selector(selectGraph), name: Notification.Name(rawValue: "selectGraph"), object: nil)
        
    }
    
    private func configureButtons()
    {
        recenterButton.translatesAutoresizingMaskIntoConstraints = false
        recenterButton.setImage(UIImage(systemName: "location.circle"), for: .normal)
        recenterButton.tintColor = .white
        recenterButton.backgroundColor = .gray
        recenterButton.layer.cornerRadius = 10
        recenterButton.addTarget(self, action: #selector(recenter), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        cancelButton.tintColor = .white
        cancelButton.backgroundColor = .cyan
        cancelButton.layer.cornerRadius = 10
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(cancelRoute), for: .touchUpInside)
        
        toggleGraphButton.translatesAutoresizingMaskIntoConstraints = false
        toggleGraphButton.setImage(UIImage(systemName: "perspective"), for: .normal)
        toggleGraphButton.tintColor = .white
        toggleGraphButton.backgroundColor = .lightText
        toggleGraphButton.layer.cornerRadius = 10
        toggleGraphButton.addTarget(self, action: #selector(toggleGraph), for: .touchUpInside)
        
        view.addSubview(toggleGraphButton)
        view.addSubview(recenterButton)
        view.addSubview(cancelButton)
        
        recenterButtonYConstraint = recenterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        cancelButtonYContraint =             cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        
        NSLayoutConstraint.activate([
            recenterButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            recenterButtonYConstraint,
            recenterButton.heightAnchor.constraint(equalToConstant: 40),
            recenterButton.widthAnchor.constraint(equalToConstant: 40),
            cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20), cancelButtonYContraint,
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.widthAnchor.constraint(equalToConstant: 40),
            toggleGraphButton.leftAnchor.constraint(equalTo: recenterButton.leftAnchor),
            toggleGraphButton.topAnchor.constraint(equalTo: recenterButton.bottomAnchor),
            toggleGraphButton.heightAnchor.constraint(equalToConstant: 40),
            toggleGraphButton.widthAnchor.constraint(equalToConstant: 40)])
        
    }
    @objc func toggleGraph()
    {
        if Self.routeInProgress
        {
            cancelRoute()
        }
        if !isRealTimeGraph
        {
            InteractiveMapViewController.selectedGraph = TrailsDatabase.realTimeGraph
            isRealTimeGraph = true
            selectGraph()
        }
        else
        {
            InteractiveMapViewController.selectedGraph = TrailsDatabase.graph
            isRealTimeGraph = false
            selectGraph()
        }
    }
    @objc func selectGraph()
    {
        myMap.removeOverlays(myMap.overlays)
        myMap.removeAnnotations(myMap.annotations)
        showAllTrails()
    }
    @objc func cancelRoute()
    {
        InteractiveMapViewController.routeInProgress = false
        InteractiveMapViewController.destination = nil
        InteractiveMapViewController.origin = nil
        self.trailSelectorView?.isPresented = false
        self.cancelButton.isHidden = true
        InteractiveMapViewController.selectedGraph.removeLastVertex()
        showAllTrails()
    }
    @objc func recenter()
    {
        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let myLocation = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion.init(center: myLocation, span: span)
        myMap.setRegion(region, animated: false)
        let mapCamera = MKMapCamera(lookingAtCenter: myLocation, fromDistance: 1000, pitch: 60, heading: 50)
        myMap.setCamera(mapCamera, animated: false)
        myMap.setUserTrackingMode(.follow, animated: true)
    }
    
    private func checkUserDefaults()
    {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return
        }
        getSingleUser(id: userId, completion: { result in
            guard let user = try? result.get() else
            {
                print("Error: \(result)")
                return
            }
            InteractiveMapViewController.currentUser = user
        })
        
    }
    private func configureClasses()
    {
        if (!Self.configuredClasses)
        {
            TrailsDatabase.addVertexes()
            TrailsDatabase.createEdges(graph: InteractiveMapViewController.selectedGraph)
            Self.configuredClasses = true
        }
    }
    
    private func configureSearchBar()
    {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.initialFrame = CGRect(x: 20, y: 40, width: 40, height: 40)
        searchBar.extendedFrame = CGRect(x: 20, y: 40, width: view.bounds.width - 36, height: 40)
        searchBar.droppedDownFrame = CGRect(x: 20, y: 40, width: view.bounds.width - 36, height: 80)
        searchBar.setInitialFrame()
        searchBar.reloadView()
        searchBar.destinationTextField.delegate = self
        searchBar.originTextField.delegate = self
        searchBar.directionsButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
        searchBar.directionsButton.addTarget(self, action: #selector(moveTrailSelectorView), for: .touchUpInside)
        searchBar.searchButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
        
        view.addSubview(searchBar)
    }
    @objc func reloadButtons()
    {
        if(searchBar.isDroppedDown)
        {
            recenterButtonYConstraint.constant = 120
            cancelButtonYContraint.constant = 120
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            recenterButtonYConstraint.constant = 80
            cancelButtonYContraint.constant = 80
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    @objc func moveTrailSelectorView()
    {
        if(searchBar.isDroppedDown && trailSelectorView!.isPresented)
        {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.trailSelectorView?.frame = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: nil)
        }
        else if(trailSelectorView!.isPresented)
        {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.trailSelectorView?.frame = CGRect(x: 0, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            }, completion: nil)
        }
    }
    private func configureTrailSelectorView()
    {
        self.trailSelectorView = TrailSelectorView(frame: CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        trailSelectorView?.configureTableViewAndSearchBar()
        let window = self.view
        trailSelectorMenu = SideMenuFramework(viewController: self, window: window!, screenSize: UIScreen.main.bounds.size, width: UIScreen.main.bounds.size.width)
        trailSelectorMenu?.view = trailSelectorView
    }
    
    @objc func presentSideMenu()
    {
        
        if searchBar.isDroppedDown
        {
            self.trailSelectorView!.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu?.presentDroppedDownItems()
            trailSelectorView?.isPresented = true
        }
        else
        {
            self.trailSelectorView!.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu?.presentItems()
            trailSelectorView?.isPresented = true
        }
    }
    
    @objc func selectedTrail(sender: Notification)
    {
        self.searchBar.destinationTextField.text = nil
        self.searchBar.originTextField.text = nil
        self.searchBar.isDroppedDown = false
        self.trailSelectorView?.isPresented = false
        trailSelectorMenu?.dismissItems()
        self.reloadButtons()
        sampleRoute()
        return
    }
    
    ///configureTrailReportVieiw: void -> void
    ///Configures and formats the trailReportTableView
    private func configureTrailReportView()
    {
        trailReportTableView.isScrollEnabled = true
        trailReportTableView.layer.cornerRadius = 15
        trailReportTableView.delegate = self
        trailReportTableView.dataSource = self
        trailReportTableView.register(TrailReportTypeTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    ///configureMyMap void -> voidj
    ///Configures and formats myMap
    private func configureMyMap()
    {
        //        setupTileRenderer()
        myMap.mapType = MKMapType.hybridFlyover
        //        myMap.mapType = MKMapType.satellite
        //        myMap.mapType = MKMapType.satelliteFlyover
        myMap.isRotateEnabled = true
        myMap.showsCompass = false
        myMap.setCamera(MKMapCamera(lookingAtCenter: myMap.centerCoordinate, fromDistance: CLLocationDistance(1200), pitch: 90, heading: CLLocationDirection(360)), animated: true)
        myMap.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        myMap.isZoomEnabled = true
        myMap.isScrollEnabled = true
        myMap.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 400,
            maxCenterCoordinateDistance: 12500)
        myMap.cameraBoundary = MKMapView.CameraBoundary(
            coordinateRegion: initialRegion)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addTrailReport))
        longPress.minimumPressDuration = 0.3
        myMap.userTrackingMode = .followWithHeading
        myMap.addGestureRecognizer(longPress)
        myMap.region = initialRegion
        myMap.showsUserLocation = true
        myMap.setUserTrackingMode(.followWithHeading, animated: true)
        myMap.delegate = self
        myMap.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        myMap.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        view.addSubview(myMap)
    }
    ///getTrailReportsFromDB void -> void
    ///Attempts to connect to database and adds any found trailReports to myMap
    private func getTrailReportsFromDB()
    {
        getTrailReports(completion: { value in
            guard let trailReports = try? value.get() else
            {
                print("Error: \(value)")
                return
            }
            for report in trailReports
            {
                let latitude = report.latitude
                let longitude = report.longitude
                let annotation = TrailsDatabase.createAnnotation(title: nil, latitude: latitude, longitude: longitude, difficulty: .easy)
                annotation.subtitle = "\(report.type)"
                
                let closestTrail = self.getClosestAnnotation(origin: annotation).value
                closestTrail.trailReport = annotation
                
                self.myMap.addAnnotation(annotation)
            }
        })
    }
    
    func displayCurrentTrailReports(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        for annotation in graph.vertices
        {
            if let trailReport = annotation.value.trailReport
            {
                myMap.addAnnotation(trailReport)
            }
        }
    }
    
    
    /// createConstraints: UIView, Double, Double -> void
    ///paramters:
    /// - item: The view that you want to create constraints for
    /// - distanceFromLeft: The amount of distance you want from the left side of the screens view
    /// - distanceFromTop: the amount of distance you want from the top of the screens view
    ///  Creates Constraints For the given item
    func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    /// getClosestAnnotation: ImageAnnotation -> Vertex<ImageAnnotation>
    /// paramaters:
    ///     - origin: The annotation you want to find the nearest annotation for
    /// Finds the annotation the least distacne from the passed in origin
    private func getClosestAnnotation(origin: ImageAnnotation) -> Vertex<ImageAnnotation>
    {
        self.closestAnnotation = TrailsDatabase.annotations[0]
        for annotation in TrailsDatabase.annotations
        {
            if(sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < (sqrt(pow(closestAnnotation!.value.coordinate.latitude - origin.coordinate.latitude, 2) + (pow(closestAnnotation!.value.coordinate.longitude - origin.coordinate.longitude, 2))))){
                self.closestAnnotation = annotation
            }
        }
        
        return self.closestAnnotation!
    }
    
    /// assignOrigin: void -> void
    ///  Creates an annotation for the users current location
    private func assignOrigin()
    {
        guard let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude else{
            return
        }
        InteractiveMapViewController.origin = TrailsDatabase.createAnnotation(title: "Your Location", latitude: latitude, longitude: longitude, difficulty: .easy)
        originVertex = Vertex<ImageAnnotation>(InteractiveMapViewController.origin!)
        TrailsDatabase.graph.addVertex(originVertex!)
        TrailsDatabase.graph.addEdge(direction: .directed, from: originVertex!, to: getClosestAnnotation(origin: InteractiveMapViewController.origin!), weight: 1)
        if closestAnnotation?.value == Self.destination
        {
            //Then youve completed your journey
            //figure out something to do buckoh
            cancelRoute()
            print("Huzzah")
        }
    }
    
    /// createRoute: void -> [Vertex<ImageAnnotatioin>] || null
    /// Creates a route for the easiest path from the users location to the selected destination
    func createRoute() -> [Vertex<ImageAnnotation>]?
    {
        guard let origin = InteractiveMapViewController.origin else{
            assignOrigin()
            return createRouteHelper()
        }
        originVertex = Vertex<ImageAnnotation>(origin)
        var found = false
        for annotation in TrailsDatabase.keyAnnotations
        {
            if annotation.value == originVertex!.value{
                originVertex = annotation
                found = true
                break
            }
        }
        if found
        {
            return createRouteHelper()
        }
        return nil
    }
    private func createRouteHelper() -> [Vertex<ImageAnnotation>]?
    {
        guard let destinationAnnotation = InteractiveMapViewController.destination else { return nil }
        var destinationVertex : Vertex<ImageAnnotation> = TrailsDatabase.annotations[0]
        
        for vertex in TrailsDatabase.annotations
        {
            if vertex.value.coordinate.latitude == destinationAnnotation.coordinate.latitude && vertex.value.coordinate.longitude == destinationAnnotation.coordinate.longitude
            {
                destinationVertex = vertex
            }
        }
        
        if let pathToDestination = DijkstraShortestPath(InteractiveMapViewController.selectedGraph, source: originVertex!).pathTo(destinationVertex)
        {
            self.pathCreated = pathToDestination
            return pathToDestination
        }
        return nil
    }
    
    /// sampleRoute: void -> void
    ///  Presents a routeOverviewMenu for the selected path
    func sampleRoute()
    {
        self.searchBar.dismissExtendedView()
        let destinationAnnotation = InteractiveMapViewController.destination!
        print("test1")
        if let pathToDestination = createRoute(){
            print("test2")
            var description = ""
            var trailReports = ""
            var count = 0
            for edge in pathToDestination
            {
                for annotation in TrailsDatabase.keyAnnotations
                {
                    if (annotation.value == edge.value) && (!description.contains(annotation.value.title!))
                    {
                        count += 1
                        myMap.addAnnotation(annotation.value)
                        description.append("\(edge.value.title!); ")
                    }
                }
                if let trailReport = (edge.value.trailReport)
                {
                    trailReports.append("\(trailReport.subtitle!) ")
                }
            }
            if(!InteractiveMapViewController.routeInProgress)
            {
                routeOverviewView = RouteOverviewView(frame: self.view.frame)
                self.totalDirections = description
                if description.isEmpty
                {
                    routeOverviewView!.directionsLabel.text = "Could not find Route"
                    routeOverviewView?.viewFullDirectionsButton.isHidden = true
                }
                else if count <= 2
                {
                    let index = description.index(description.startIndex, offsetBy: description.count - 2)
                    description = String(description.prefix(upTo: index))
                    routeOverviewView!.directionsLabel.text = "\(description)"
                    routeOverviewView?.viewFullDirectionsButton.isHidden = false
                    
                }
                else
                {
                    var searchRange = description.startIndex..<description.endIndex
                    var indices: [String.Index] = []
                    while let range = description.range(of: ";", options: .caseInsensitive, range: searchRange)
                    {
                        searchRange = range.upperBound..<searchRange.upperBound
                        indices.append(range.lowerBound)
                    }
                    routeOverviewView!.directionsLabel.text = "\(description.prefix(upTo: indices[1]))"
                    routeOverviewView?.viewFullDirectionsButton.isHidden = false
                    
                }
                
                routeOverviewView!.tripLbl.text = "\(InteractiveMapViewController.origin!.title!) -> \(destinationAnnotation.title!)"
                routeOverviewView!.trailReportLabel.text = trailReports
                routeOverviewView!.viewFullDirectionsButton.addTarget(self, action: #selector(presentFullDirections), for: .touchUpInside)
                routeOverviewView!.configureItems()
                presentRouteOverviewMenu()
                InteractiveMapViewController.routeInProgress = true
                
                let zoomSpan = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(180), longitudeDelta: CLLocationDegrees(180))
                let zoomCoordinate = Self.destination?.coordinate ?? myMap.region.center
                let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
                myMap.setRegion(zoomed, animated: true)
            }
            return
        }
    }
    
    @objc func presentFullDirections()
    {
        guard let fullDirections = self.totalDirections else { return }
        //show some sort of direction pop up
        print(fullDirections)
    }
    
    /// displayRoute: void -> void
    /// Shows the selected route on the map
    func displayRoute()
    {
        myMap.removeOverlays(myMap.overlays)
        myMap.removeAnnotations(myMap.annotations)
        guard let route = self.pathCreated else
        {
            print("test")
            if let pathToDestination = createRoute()
            {
                displayRouteHelper(route: pathToDestination)
            }
            return
        }
        displayRouteHelper(route: route)
        self.pathCreated = nil
    }
    
    func displayRouteHelper(route: [Vertex<ImageAnnotation>])
    {
        var previousEdge = route[0]
        
        for edge in route{
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
            if let trailReport = edge.value.trailReport
            {
                myMap.addAnnotation(trailReport)
            }
            for annotation in TrailsDatabase.keyAnnotations
            {
                if(annotation.value == edge.value)
                {
                    myMap.addAnnotation(annotation.value)
                }
            }
            previousEdge = edge
        }
        
        canFindPathAgain = true
    }
    
    
    /// showAllTrails: void -> void
    /// Shows all the trails on the map
    private func showAllTrails()
    {
        myMap.removeOverlays(myMap.overlays)
        for edge in Self.selectedGraph.edges(){
            if(edge.source.value.difficulty == .easy)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = UIColor(red: 0.03, green: 0.25, blue: 0, alpha: 1)
            }
            else if (edge.source.value.difficulty == .intermediate)
            {
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                myPolyLine.color = UIColor(red: 0.03, green: 0, blue: 0.5, alpha: 1)
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
                myPolyLine.color =  UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
            }
            myMap.addOverlay(myPolyLine, level: .aboveRoads)
        }
        createKeyTrailAnnotations()
        displayCurrentTrailReports(graph: InteractiveMapViewController.selectedGraph)
    }
    
    /// addTrailReport: UIGestureRecognizer -> void
    /// paramaters:
    /// - gesture: The tap gesture that calls this function
    ///  When the user holds a point on the map, present the Trail Report Menu
    @objc func addTrailReport(gesture: UIGestureRecognizer) {
        
        if gesture.state == .ended {
            
            if let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                self.trailReportAnnotation = ImageAnnotation()
                self.trailReportAnnotation.coordinate = coordinate
                presentTrailReportMenu()
            }
        }
    }
    
    /// presentTrailReportMenu: void -> void
    /// Configures and presents the Trail Report Menu
    private func presentTrailReportMenu()
    {
        trailReportTableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 250)
        let window = self.view
        trailReportMenu = PopUpMenuFramework(viewController: self, window: window!, screenSize: UIScreen.main.bounds.size, transparentView: UIView(frame: self.view.frame), height: 300)
        trailReportMenu?.view = trailReportTableView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTrailReportMenu))
        trailReportMenu?.transparentView.addGestureRecognizer(dismissTapGesture)
        trailReportMenu?.presentItems()
    }
    
    /// createKeyTrailAnnotations: void -> void
    ///  Presents all the key annotations to the map
    func createKeyTrailAnnotations()
    {
        if isRealTimeGraph
        {
            for annotation in TrailsDatabase.keyAnnotations
            {
                if annotation.value.status != .closed
                {
                    myMap.addAnnotation(annotation.value)
                }
            }
        }
        else
        {
            for annotation in TrailsDatabase.keyAnnotations
            {
                myMap.addAnnotation(annotation.value)
            }
        }
    }
    
    /// dismissMenu: void -> void
    /// dismisses the Trail Report Menu
    @objc func dismissTrailReportMenu() {
        trailReportMenu!.dismissItems()
    }
    
    /// presentRouteOverviewMenu: void -> void
    /// configures the Route Overview View, presents the associated menu on the screen and displays the route on the menu
    private func presentRouteOverviewMenu()
    {
        routeOverviewView!.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200)
        let window = self.view
        routeOverviewMenu = PopUpMenuFramework(viewController: self, window: window!, screenSize: UIScreen.main.bounds.size, transparentView: UIView(frame: self.view.frame), height: 300)
        routeOverviewMenu?.view = routeOverviewView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissRouteOverviewMenu))
        routeOverviewMenu?.transparentView.addGestureRecognizer(dismissTapGesture)
        routeOverviewView?.letsGoButton.addTarget(self, action: #selector(letsGoButtonPressed), for: .touchUpInside)
        routeOverviewMenu?.presentItems()
        displayRoute()
    }
    
    /// dismissRouteOverviewMenu: void -> void
    /// dismisses the route overview menu and cancels any on going routes
    @objc func dismissRouteOverviewMenu()
    {
        self.cancelButton.isHidden = true
        InteractiveMapViewController.destination = nil
        InteractiveMapViewController.origin = nil
        InteractiveMapViewController.routeInProgress = false
        viewDidAppear(true)
        self.routeOverviewMenu?.dismissItems()
    }
    
    /// letsGoButtonPressed: void -> void
    /// dismisses the route overview menu
    @objc func letsGoButtonPressed()
    {
        self.routeOverviewMenu?.dismissItems()
        self.cancelButton.isHidden = false
        
        recenter()
        
        Self.origin = nil
        guard let currentUserId = InteractiveMapViewController.currentUser?.id else{return}
        self.saveUserRoute(UserRoute(destinationTrailName: (InteractiveMapViewController.destination?.title)!, originTrailName: (self.closestAnnotation?.value.title)!, dateMade: "\(Date.now)", timeTook: 0, userID: currentUserId))
    }
    
    /// createTrailReport: TrailReportType -> void
    /// parameters:
    /// - type: The Trail Report Type for the Trail Report
    /// Creates a Trail Report of the specified type on the map and sends itself to the database
    func createTrailReport(type: TrailReportType)
    {
        dismissTrailReportMenu()
        let originAnnotation = TrailsDatabase.createAnnotation(title: nil, latitude: self.trailReportAnnotation.coordinate.latitude, longitude: self.trailReportAnnotation.coordinate.longitude, difficulty: .easy)
        let closestTrail = getClosestAnnotation(origin: originAnnotation).value
        switch type
        {
        case .moguls:
            originAnnotation.subtitle = "Moguls"
        case .ice:
            originAnnotation.subtitle = "Icy"
        case .crowded:
            originAnnotation.subtitle = "Crowded"
        }
        guard let currentUserId = InteractiveMapViewController.currentUser?.id else { return }
        saveTrailReporrt(TrailReport(type: originAnnotation.subtitle!, latitude: originAnnotation.coordinate.latitude, longitude: originAnnotation.coordinate.longitude, dateMade: "\(Date.now)", trailMadeOn: closestTrail.title!, userID: "\(currentUserId)"))
        closestTrail.trailReport = originAnnotation
        myMap.addAnnotation(originAnnotation)
        
    }
    
    /// saveTrailReport: TrailReport -> void
    /// parameters:
    /// - trailReport: the trail report to be sent to the database
    /// sends the given trail report to the database
    func saveTrailReporrt(_ trailReport: TrailReport) {
        let url = URL(string: "http://localhost:8080/api/trail-reports")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(trailReport)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let item = try? decoder.decode(TrailReport.self, from: data) {
                    print(item.type)
                } else {
                    print(data)
                    print("Bad JSON received back.")
                }
            }
        }.resume()
    }
    
    func getSingleUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "http://127.0.0.1:8080/api/users/\(id)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                print("Unable to parse JSON response.")
                completion(.failure(error!))
            }
        }.resume()
    }
    /// getTrailReports: void -> [TrailReport] || Error
    /// gets all the trail reports being stored on the database
    func getTrailReports(completion: @escaping (Result<[TrailReport], Error>) -> Void) {
        let url = URL(string: "http://127.0.0.1:8080/api/trail-reports")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let trailReports = try? decoder.decode([TrailReport].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(trailReports))
                }
            } else {
                print("Unable to parse JSON response.")
                completion(.failure(error!))
            }
        }.resume()
    }
    func saveUserRoute(_ userRoute: UserRoute) {
        let url = URL(string: "http://localhost:8080/api/user-routes/")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(userRoute)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let item = try? decoder.decode(UserRoute.self, from: data) {
                    print(item.destinationTrailName)
                } else {
                    print(data)
                    print("Bad JSON received back.")
                }
            }
        }.resume()
    }
    func saveUserLocation(_ userLocation: UserLocation) {
        let url = URL(string: "http://localhost:8080/api/user-locations")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(userLocation)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if (try? decoder.decode(UserLocation.self, from: data)) != nil {
                    
                } else {
                    print(data)
                    print("Bad JSON received back.")
                }
            }
        }.resume()
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
        let currentSpan = mapView.region.span
        let zoomSpan = MKCoordinateSpan(latitudeDelta: currentSpan.latitudeDelta / 2.0, longitudeDelta: currentSpan.longitudeDelta / 2.0)
        let zoomCoordinate = view.annotation?.coordinate ?? mapView.region.center
        let zoomed = MKCoordinateRegion(center: zoomCoordinate, span: zoomSpan)
        mapView.setRegion(zoomed, animated: true)
        guard let annotation = view.annotation as? ImageAnnotation else {
            return
        }
        if let status = annotation.status
        {
            print(status)
        }
        if view.annotation is MKUserLocation
        {
            return
            //then you selected the user location
        }
        if (view.annotation?.title! == nil)
        {
            return
            //then its a trail report
        }
        if Self.routeInProgress
        {
            return
        }
        InteractiveMapViewController.destination = view.annotation as? ImageAnnotation
        sampleRoute()
    }
}

extension InteractiveMapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TrailReportTypeTableViewCell else {fatalError("Unable to deque cell")}
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
        let cell = tableView.cellForRow(at: indexPath) as! TrailReportTypeTableViewCell
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
            dismissTrailReportMenu()
        }
    }
}

extension InteractiveMapViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        trailSelectorView?.currentTextField = textField
        if textField.placeholder == "Origin: Your Location..."
        {
            trailSelectorView?.currentTextFieldType = .origin
        }
        else {
            trailSelectorView?.currentTextFieldType = .destination
        }
        if(trailSelectorView!.isPresented)
        {
            return true
        }
        else
        {
            presentSideMenu()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchTrail"), object: nil)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        TrailSelectorView.searchText = textField.text!
        NotificationCenter.default.post(name: Notification.Name(rawValue: "searchTrail"), object: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(InteractiveMapViewController.wasCancelled)
        if InteractiveMapViewController.wasCancelled{
            self.trailSelectorMenu?.dismissItems()
            self.trailSelectorView?.isPresented = false
            self.searchBar.destinationTextField.text = nil
            InteractiveMapViewController.wasCancelled = false
        }
        else{
            return
        }
    }
}

extension InteractiveMapViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if Self.routeInProgress && canFindPathAgain
        {
            InteractiveMapViewController.selectedGraph.removeLastVertex()
            Self.origin = nil
            canFindPathAgain = false
            displayRoute()
        }
        guard let currentUserId = InteractiveMapViewController.currentUser?.id else
        {
            return
        }
        saveUserLocation(UserLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude, timeReported: "\(locations[0].timestamp)", userID: currentUserId))
        
    }
}
