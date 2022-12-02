//
//  Self.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/25/22.
//
import SwiftUI
import Foundation
import UIKit
import MapKit
import CoreLocation

class InteractiveMapViewController: UIViewController
{
    @ObservedObject private var connectivityController = ConnectivityController.shared
    
    static var currentUser : User?
    static var routeInProgress = false
    static var destination : ImageAnnotation?
    static var configuredClasses = false
    static var wasCancelled = false
    static var origin : ImageAnnotation?
    static var selectedGraph = TrailsDatabase.graph
    static var wasSelectedWithOrigin = false
    static var didChooseDestination = false
    
    let baseURL = "http://35.172.135.117"
    
    var trailReports : [TrailReport]?
    var selectedTrailReport : TrailReport?
    var selectedTrailReportAnnotation : ImageAnnotation?
    
    var cancelTrailReportView = CancelTrailReportView()
    
    var gestureTimer = Date()
    
    var allTrailMapView = MKMapView()
    
    var canFindPathAgain = true
    var isRealTimeGraph = false
    var toggleGraphButton = UIButton()
    var followingRoute = false
    
    let initialRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.46806937533083, longitude: -70.87985973100996),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
    
    var initialLocation : String?
    var timer = Date()
    var myMap = MKMapView()
    var tileRenderer: MKTileOverlayRenderer!
    var myPolyLine = CustomPolyline()
    
    var cancelButton = UIButton()
    var cancelButtonYContraint = NSLayoutConstraint()
    var searchBar = SearchBarTableHeaderView()
    var pathCreated: [Vertex<ImageAnnotation>] = []
    
    var settingArray = ["Moguls", "Icy", "Crowded", "Thin Cover", "Cancel"]
    var trailReportMenu : PopUpMenuFramework?
    var trailReportTableView = UITableView()
    
    let locationManager = LocationManager()
    
    var routeOverviewMenu : PopUpMenuFramework?
    var routeOverviewView : RouteOverviewView?
    
    var trailReportAnnotation = ImageAnnotation()
    
    var originVertex : Vertex<ImageAnnotation>?
    
    var trailSelectorView : TrailSelectorView?
    var trailSelectorMenu : SideMenuFramework?
        
    var totalDirections : String?
    
    var recenterButton = UIButton()
    var recenterButtonYConstraint = NSLayoutConstraint()
    
    var previousClosestAnnotation : Vertex<ImageAnnotation>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTrailReportView()
        configureClasses()
        configureMyMap()
        configureSearchBar()
        checkUserDefaults()
        configureButtons()
        locationManager.locationManager.delegate = self
        locationManager.locationManager.requestWhenInUseAuthorization()
        locationManager.locationManager.startUpdatingHeading()
        locationManager.locationManager.startUpdatingLocation()
        getTrailReportsFromDB()
        
        WebAnalysis.shared.makeRequest()
        MapInterpreter.shared.getMap(id: "861C6942-5B8C-4A1A-8573-B919A962DCA4")
        
        
        self.tabBarController?.tabBar.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(selectedTrail), name: Notification.Name(rawValue: "selectedTrail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectGraph), name: Notification.Name(rawValue: "selectGraph"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(configureTrailSelectorView), name: Notification.Name("configureTrailSelector"), object: nil)
        if Self.destination != nil {
            sampleRoute()
        }
        else {
            showAllTrails()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self.trailSelectorView as Any, name: Notification.Name(rawValue: "searchTrail"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectedTrail"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectGraph"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("configureTrailSelector"), object: nil)
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
        let selectTrailGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        let trailReportGesture = UILongPressGestureRecognizer(target: self, action: #selector(addTrailReport))
        trailReportGesture.minimumPressDuration = 0.3
        myMap.addGestureRecognizer(trailReportGesture)
        myMap.addGestureRecognizer(selectTrailGesture)
        myMap.userTrackingMode = .followWithHeading
        myMap.region = initialRegion
        myMap.showsUserLocation = true
        myMap.setUserTrackingMode(.followWithHeading, animated: true)
        myMap.delegate = self
        myMap.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        myMap.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        view.addSubview(myMap)
    }
    @objc func mapTapped(_ tap: UITapGestureRecognizer) {
        if tap.state == .recognized {
            // Get map coordinate from touch point
            let touchPt: CGPoint = tap.location(in: myMap)
            let coord: CLLocationCoordinate2D = myMap.convert(touchPt, toCoordinateFrom: myMap)
            let maxMeters: Double = meters(fromPixel: 22, at: touchPt)
            var nearestDistance: Float = MAXFLOAT
            var nearestPoly: CustomPolyline? = nil
            // for every overlay ...
            for overlay: MKOverlay in myMap.overlays {
                // .. if MKPolyline ...
                if (overlay is MKPolyline) {
                    // ... get the distance ...
                    let distance: Float = Float(distanceOf(pt: MKMapPoint(coord), toPoly: overlay as! MKPolyline))
                    // ... and find the nearest one
                    if distance < nearestDistance {
                        nearestDistance = distance
                        nearestPoly = overlay as? CustomPolyline
                    }

                }
            }
            if Double(nearestDistance) <= maxMeters {
                if let line = nearestPoly
                {
                    let initialAnnotation = line.initialAnnotation!
                    let coordinate = initialAnnotation.coordinate
                    var closestVertex = Self.selectedGraph.vertices[0]
                    
                    for vertex in Self.selectedGraph.vertices
                    {
                        if(sqrt(pow(vertex.value.coordinate.latitude - coordinate.latitude, 2) + pow(vertex.value.coordinate.longitude - coordinate.longitude, 2)) < (sqrt(pow(closestVertex.value.coordinate.latitude - coordinate.latitude, 2) + (pow(closestVertex.value.coordinate.longitude - coordinate.longitude, 2))))){
                            closestVertex = vertex
                        }
                    }
                    print(Self.selectedGraph.vertices.contains(closestVertex))
                    Self.origin = nil
                    Self.wasSelectedWithOrigin = false
                    Self.destination = closestVertex.value
                    sampleRoute()
                }

            }
        }
    }

    private func distanceOf(pt: MKMapPoint, toPoly poly: MKPolyline) -> Double {
        var distance: Double = Double(MAXFLOAT)
        for n in 0..<poly.pointCount - 1 {
            let ptA = poly.points()[n]
            let ptB = poly.points()[n + 1]
            let xDelta: Double = ptB.x - ptA.x
            let yDelta: Double = ptB.y - ptA.y
            if xDelta == 0.0 && yDelta == 0.0 {
                // Points must not be equal
                continue
            }
            let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var ptClosest: MKMapPoint
            if u < 0.0 {
                ptClosest = ptA
            }
            else if u > 1.0 {
                ptClosest = ptB
            }
            else {
                ptClosest = MKMapPoint(x: ptA.x + u * xDelta, y: ptA.y + u * yDelta)
            }

            distance = min(distance, ptClosest.distance(to: pt))
        }
        return distance
    }

    private func meters(fromPixel px: Int, at pt: CGPoint) -> Double {
        let ptB = CGPoint(x: pt.x + CGFloat(px), y: pt.y)
        let coordA: CLLocationCoordinate2D = myMap.convert(pt, toCoordinateFrom: myMap)
        let coordB: CLLocationCoordinate2D = myMap.convert(ptB, toCoordinateFrom: myMap)
        return MKMapPoint(coordA).distance(to: MKMapPoint(coordB))
    }
    
    private func configureButtons()
    {
        configureIndividualButton(button: recenterButton, backgroundColor: .gray, image: UIImage(systemName: "location.circle")!)
        recenterButton.addTarget(self, action: #selector(recenter), for: .touchUpInside)
        
        configureIndividualButton(button: cancelButton, backgroundColor: .cyan, image: UIImage(systemName: "xmark.circle.fill")!)
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(cancelRoute), for: .touchUpInside)
        
        configureIndividualButton(button: toggleGraphButton, backgroundColor: .lightText, image: UIImage(systemName: "perspective")!)
        toggleGraphButton.addTarget(self, action: #selector(toggleGraph), for: .touchUpInside)
        
        recenterButtonYConstraint = recenterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        cancelButtonYContraint = cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        
        cancelTrailReportView.isHidden = true
        cancelTrailReportView.configure()
        cancelTrailReportView.notThereUIButton.addTarget(self, action: #selector(removeTrailReport), for: .touchUpInside)
        view.addSubview(cancelTrailReportView)
        
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
            toggleGraphButton.widthAnchor.constraint(equalToConstant: 40),
            cancelTrailReportView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelTrailReportView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelTrailReportView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 150),
            cancelTrailReportView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height - 110)
            ])
    }
    @objc func removeTrailReport()
    {
        let annotation = TrailsDatabase.annotations.first(where: {$0.value.trailReport == selectedTrailReportAnnotation})
        guard let selectedTrailReport = self.selectedTrailReport else {
            myMap.removeAnnotation(selectedTrailReportAnnotation!)
            annotation?.value.trailReport = nil
            selectedTrailReportAnnotation = nil
            //Then the trail report hasnt been stored on the database yet
            return
        }
        deleteTrailReport(id: selectedTrailReport.id)
        self.selectedTrailReport = nil
        myMap.removeAnnotation(selectedTrailReportAnnotation!)
        annotation?.value.trailReport = nil
        selectedTrailReportAnnotation = nil
        
    }
    func configureIndividualButton(button: UIButton, backgroundColor: UIColor, image: UIImage)
    {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 10
        view.addSubview(button)
    }
    
    @objc func toggleGraph()
    {
        if Self.routeInProgress
        {
            cancelRoute()
        }
        if !isRealTimeGraph
        {
            Self.selectedGraph = MapInterpreter.shared.graph
            //Self.selectedGraph = TrailsDatabase.realTimeGraph
            isRealTimeGraph = true
        }
        else
        {
            Self.selectedGraph = TrailsDatabase.graph
            isRealTimeGraph = false
        }
        showAllTrails()
    }
    
    @objc func selectGraph()
    {
        showAllTrails()
    }
    
    @objc func cancelRoute()
    {
        self.initialLocation = nil
        Self.routeInProgress = false
        Self.destination = nil
        Self.origin = nil
        self.pathCreated = []
        self.trailSelectorView?.isPresented = false
        self.cancelButton.isHidden = true
        Self.selectedGraph.removeLastVertex()
        showAllTrails()
    }
    @objc func recenter()
    {
        let span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let myLocation = CLLocationCoordinate2D(latitude: locationManager.locationManager.location!.coordinate.latitude, longitude: locationManager.locationManager.location!.coordinate.longitude)
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
            Self.currentUser = user
        })
        
    }
    private func configureClasses()
    {
        if (!Self.configuredClasses)
        {
            TrailsDatabase.addVertexes()
            TrailsDatabase.createEdges(graph: Self.selectedGraph)
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
        searchBar.searchButton.addTarget(self, action: #selector(dismissSideMenu), for: .touchUpInside)
        
        view.addSubview(searchBar)
    }
    @objc func dismissSideMenu()
    {
        if trailSelectorView!.isPresented
        {
            self.trailSelectorMenu?.dismissItems()
            self.trailSelectorView?.isPresented = false
            self.searchBar.destinationTextField.text = nil
            self.searchBar.originTextField.text = nil
            Self.wasCancelled = false
        }
    }
    @objc func reloadButtons()
    {
        if(searchBar.isDroppedDown)
        {
            recenterButtonYConstraint.constant = 120
            cancelButtonYContraint.constant = 120
            animateLayoutChange()
        }
        else
        {
            recenterButtonYConstraint.constant = 80
            cancelButtonYContraint.constant = 80
            animateLayoutChange()
        }
    }
    
    private func animateLayoutChange()
    {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    @objc func configureTrailSelectorView()
    {
        self.trailSelectorView = TrailSelectorView(frame: CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        trailSelectorView?.configureTableViewAndSearchBar()
        let window = self.view
        trailSelectorMenu = SideMenuFramework(viewController: self, window: window!, screenSize: UIScreen.main.bounds.size, width: UIScreen.main.bounds.size.width)
        trailSelectorMenu?.view = trailSelectorView
        NotificationCenter.default.addObserver(self.trailSelectorView as Any, selector: #selector(trailSelectorView?.filterTrails), name: Notification.Name(rawValue: "searchTrail"), object: nil)
    }
    
    @objc func presentSideMenu()
    {
        
        if searchBar.isDroppedDown
        {
            self.trailSelectorView!.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu?.presentDroppedDownItems()
        }
        else
        {
            self.trailSelectorView!.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu?.presentItems()
        }
        trailSelectorView?.isPresented = true
    }
    
    @objc func selectedTrail()
    {
        self.searchBar.destinationTextField.text = nil
        self.searchBar.originTextField.text = nil
        self.searchBar.isDroppedDown = false
        self.trailSelectorView?.isPresented = false
        trailSelectorMenu?.dismissItems()
        self.reloadButtons()
        sampleRoute()
    }
    
    ///configureTrailReportVieiw: void -> void
    ///Configures and formats the trailReportTableView
    private func configureTrailReportView()
    {
        trailReportTableView.isScrollEnabled = true
        trailReportTableView.layer.cornerRadius = 15
        trailReportTableView.delegate = self
        trailReportTableView.dataSource = self
        trailReportTableView.register(TrailReportTypeTableViewCell.self, forCellReuseIdentifier: "TrailReportTypeTableViewCell")
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
            self.trailReports = trailReports
            for report in trailReports
            {
                let latitude = report.latitude
                let longitude = report.longitude
                let annotation = createAnnotation(title: nil, latitude: latitude, longitude: longitude, difficulty: .easy)
                annotation.subtitle = "\(report.type)"
                annotation.id = report.id
                let closestTrail = self.getClosestAnnotation(origin: annotation).value
                closestTrail.trailReport = annotation
                self.myMap.addAnnotation(annotation)
                self.locationManager.makeTrailReportRegion(trailReport: annotation)
                self.locationManager.registerNotification(title: "CAUTION: \(annotation.subtitle!.uppercased()) AHEAD", body: annotation.subtitle!, trailReportID: report.id!)
            }
        })
    }
    
    func displayCurrentTrailReports(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        myMap.addAnnotations(graph.vertices.map({ $0.value }).filter({ $0.trailReport != nil }).map({ $0.trailReport! }))
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
        if Self.selectedGraph.vertices.last == Vertex<ImageAnnotation>(origin)
        {
            Self.selectedGraph.removeLastVertex()
        }
        var closestAnnotation = Self.selectedGraph.vertices[0]
        for annotation in Self.selectedGraph.vertices
        {
            if(sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < (sqrt(pow(closestAnnotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + (pow(closestAnnotation.value.coordinate.longitude - origin.coordinate.longitude, 2)))))
            {
                closestAnnotation = annotation
            }
        }
        return closestAnnotation
    }
    
    /// assignOrigin: void ->  Bool
    ///  Creates an annotation for the users current location if the user allows access to its location
    private func assignOrigin() -> Bool
    {
        guard let latitude = locationManager.locationManager.location?.coordinate.latitude, let longitude = locationManager.locationManager.location?.coordinate.longitude, locationManager.locationManager.authorizationStatus == .authorizedWhenInUse else {
            return false
        }
        Self.origin = createAnnotation(title: "Your Location", latitude: latitude, longitude: longitude, difficulty: .easy)
        let closestVertex = getClosestAnnotation(origin: Self.origin!)
        originVertex = Vertex<ImageAnnotation>(Self.origin!)
        if pathCreated.contains(closestVertex)
        {
            for vertex in pathCreated
            {
                if vertex == closestVertex
                {
                    break
                }
                pathCreated.removeFirst()
            }
            pathCreated.insert(originVertex!, at: 0)
        }
        else
        {
            Self.selectedGraph.removeLastVertex()
            Self.selectedGraph.addVertex(originVertex!)
            Self.selectedGraph.addEdge(direction: .directed, from: originVertex!, to: closestVertex, weight: 1)
        }
        if getClosestAnnotation(origin: Self.origin!).value == Self.destination
        {
            //Then youve completed your journey
            //figure out something to do buckoh
            guard let currentUserId = Self.currentUser?.id else
            {
                cancelRoute()
                return true
            }
            saveUserRoute(UserRoute(destinationTrailName: Self.destination!.title!, originTrailName: initialLocation!, dateMade: "\(Date.now)", timeTook: Int(Date.now.timeIntervalSince(timer)), userID: currentUserId))
            cancelRoute()
            print("Huzzah")
        }
        return true
    }
    
    /// createRoute: void -> [Vertex<ImageAnnotatioin>] || null
    /// Creates a route for the easiest path from the users location to the selected destination
    func createRoute() -> [Vertex<ImageAnnotation>]?
    {
            guard let origin = Self.origin else{
                if assignOrigin()
                {
                    return manageRouteInProgress()
                }
                else
                {
                    return nil
                    //user isnt allowing location services
                }
            }
            originVertex = Vertex<ImageAnnotation>(origin)
            var found = false
            for annotation in Self.selectedGraph.vertices
            {
                if annotation.value == originVertex!.value{
                    originVertex = annotation
                    found = true
                    break
                }
            }
            if found
            {
                return manageRouteInProgress()
            }
            return nil
        
    }
    private func manageRouteInProgress() -> [Vertex<ImageAnnotation>]?
    {
        if Self.routeInProgress && !self.pathCreated.isEmpty && self.pathCreated.contains(self.originVertex!)
        {
            let pathGraph = EdgeWeightedDigraph<ImageAnnotation>()
            pathGraph.addVertex(self.pathCreated[0])
            for index in 1...self.pathCreated.count - 1
            {
                pathGraph.addVertex(self.pathCreated[index])
                pathGraph.addEdge(direction: .directed, from: self.pathCreated[index - 1], to: self.pathCreated[index], weight: 1)
            }
            print("path graph with \(pathGraph.verticesCount()) vertices and \(pathGraph.edgesCount()) edges")
            return createRouteHelper(graph: pathGraph)
        }
        else
        {
            return createRouteHelper(graph: Self.selectedGraph)
        }
    }
    
    private func createRouteHelper(graph: EdgeWeightedDigraph<ImageAnnotation>) -> [Vertex<ImageAnnotation>]?
    {
        guard let destinationAnnotation = Self.destination else { return nil }
        print("test1")
        let startTime = Date.now
        let destinationVertex : Vertex<ImageAnnotation> = graph.vertices.first(where: {$0.value == destinationAnnotation})!
        if let pathToDestination = DijkstraShortestPath(graph, source: originVertex!).pathTo(destinationVertex)
        {
            print("Took \(Date.now.timeIntervalSince(startTime)) seconds to find route")
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
        let destinationAnnotation = Self.destination!
        if let pathToDestination = createRoute(){
            var description = ""
            var trailReports = ""
            var count = 0
            var foundAnnotations : [ImageAnnotation] = []
            let mapImageAnnotations = myMap.annotations.filter({$0 as? ImageAnnotation != nil}) as! [ImageAnnotation]
        
            for vertex in pathToDestination
            {
                foundAnnotations = mapImageAnnotations.filter({
                    if($0.coordinate == vertex.value.coordinate && !description.contains($0.title!))
                    {
                        description.append("\(vertex.value.title!); ")
                        count += 1
                        return true
                    }
                    return false
                })
                myMap.removeAnnotations(myMap.annotations)
                myMap.addAnnotations(foundAnnotations)
                if let trailReport = (vertex.value.trailReport)
                {
                    trailReports.append("\(trailReport.subtitle!) ")
                }
            }
            if(!Self.routeInProgress)
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
                initialLocation = getClosestAnnotation(origin: Self.origin!).value.title
                routeOverviewView!.tripLbl.text = "\(Self.origin!.title!) -> \(destinationAnnotation.title!)"
                routeOverviewView!.trailReportLabel.text = trailReports
                routeOverviewView!.viewFullDirectionsButton.addTarget(self, action: #selector(presentFullDirections), for: .touchUpInside)
                routeOverviewView!.configureItems()
                presentRouteOverviewMenu()
                Self.routeInProgress = true
                
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
        let previousOverlays = myMap.overlays
        let previousAnnotations = myMap.annotations.filter({$0.isKind(of: ImageAnnotation.self)}) as! [ImageAnnotation]
        print(pathCreated.count)
        if let newRoute = createRoute()
        {
            print("test2")
            displayRouteHelper(route: newRoute, previousOverlays: previousOverlays, previousAnnotations: previousAnnotations)
        }
        return
    }
    
    func displayRouteHelper(route: [Vertex<ImageAnnotation>], previousOverlays: [MKOverlay], previousAnnotations: [ImageAnnotation])
    {
        var previousVertex = route[0]
        var foundAnnotations : [ImageAnnotation] = []
        var routes : [Route] = []
        var id = 0
        var foundTrails : [String] = []
        for vertex in route{
            myPolyLine = CustomPolyline(coordinates: [previousVertex.value.coordinate, vertex.value.coordinate], count: 2)
            switch previousVertex.value.difficulty
            {
            case .easy:
                myPolyLine.color = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
            case .intermediate:
                myPolyLine.color = .blue
            case .advanced:
                myPolyLine.color = .gray
            case .lift:
                myPolyLine.color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
            case .terrainPark:
                myPolyLine.color = .orange
            default:
                myPolyLine.color = .black
            }
            myPolyLine.initialAnnotation = previousVertex.value
            myMap.addOverlay(myPolyLine, level: .aboveRoads)
            if let trailReport = vertex.value.trailReport
            {
                foundAnnotations.append(trailReport)
            }
            if (!foundTrails.contains(vertex.value.title!))
            {
                foundTrails.append(vertex.value.title!)
                routes.append(Route(id: id, annotationName: vertex.value.title!, coordinates: [vertex.value.coordinate.latitude, vertex.value.coordinate.longitude]))
            }
            id += 1
            previousVertex = vertex
        }
        let set1 = Set(previousAnnotations)
        let set2 = set1.subtracting(foundAnnotations)
        myMap.removeAnnotations(Array(set2))
        myMap.addAnnotations(foundAnnotations)
        myMap.removeOverlays(previousOverlays)
        connectivityController.setRoute(route: routes)
        canFindPathAgain = true
    }
    
    
    /// showAllTrails: void -> void
    /// Shows all the trails on the map
    private func showAllTrails()
    {
        myMap.removeOverlays(myMap.overlays)
        myMap.removeAnnotations(myMap.annotations)
        if Self.selectedGraph.vertices == TrailsDatabase.graph.vertices
        {
            for edge in Self.selectedGraph.edges(){
                myPolyLine = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                switch edge.source.value.difficulty{
                case .easy:
                    myPolyLine.color = UIColor(red: 0.03, green: 0.25, blue: 0, alpha: 1)
                case .intermediate:
                    myPolyLine.color = UIColor(red: 0.03, green: 0, blue: 0.5, alpha: 1)
                case .advanced:
                    myPolyLine.color = .gray
                case .lift:
                    myPolyLine.color = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
                case .terrainPark:
                    myPolyLine.color = .orange
                default:
                    myPolyLine.color = .black
                }
                myPolyLine.initialAnnotation = edge.source.value
                myMap.addOverlay(myPolyLine, level: .aboveRoads)
            }
            createKeyTrailAnnotations()
            displayCurrentTrailReports(graph: Self.selectedGraph)
        }
        else
        {
            myMap.addOverlays(MapInterpreter.shared.mapView.overlays)
            myMap.addAnnotations(MapInterpreter.shared.mapView.annotations)
        }
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
            myMap.addAnnotations(TrailsDatabase.keyAnnotations.map({ $0.value }).filter({ $0.status == .open }))
        }
        else
        {
            myMap.addAnnotations(TrailsDatabase.keyAnnotations.map({ $0.value }))
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
        cancelRoute()
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
        guard (Self.currentUser?.id) != nil else{return}
        self.timer = Date.now
    }
    
    /// createTrailReport: TrailReportType -> void
    /// parameters:
    /// - type: The Trail Report Type for the Trail Report
    /// Creates a Trail Report of the specified type on the map and sends itself to the database
    func createTrailReport(type: TrailReportType)
    {
        dismissTrailReportMenu()
        let originAnnotation = createAnnotation(title: nil, latitude: self.trailReportAnnotation.coordinate.latitude, longitude: self.trailReportAnnotation.coordinate.longitude, difficulty: .easy)
        let closestTrail = getClosestAnnotation(origin: originAnnotation).value
        switch type
        {
        case .moguls:
            originAnnotation.subtitle = "Moguls"
        case .ice:
            originAnnotation.subtitle = "Icy"
        case .crowded:
            originAnnotation.subtitle = "Crowded"
        case .thinCover:
            originAnnotation.subtitle = "Thin Cover"
        }
        guard let currentUserId = Self.currentUser?.id else { return }
        saveTrailReporrt(TrailReport(type: originAnnotation.subtitle!, latitude: originAnnotation.coordinate.latitude, longitude: originAnnotation.coordinate.longitude, dateMade: "\(Date.now)", trailMadeOn: closestTrail.title!, userID: "\(currentUserId)"))
        closestTrail.trailReport = originAnnotation
        myMap.addAnnotation(originAnnotation)
        
    }
    
    /// saveTrailReport: TrailReport -> void
    /// parameters:
    /// - trailReport: the trail report to be sent to the database
    /// sends the given trail report to the database
    func saveTrailReporrt(_ trailReport: TrailReport) {
        let url = URL(string: "\(baseURL)/api/trail-reports")!
        
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
        let url = URL(string: "\(baseURL)/api/users/\(id)")!
        
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
        let url = URL(string: "\(baseURL)/api/trail-reports")!
        
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
        let url = URL(string: "\(baseURL)/api/user-routes/")!
        
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
        let url = URL(string: "\(baseURL)/api/user-locations")!
        
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
    public func deleteTrailReport(id: String?)
    {
        guard let id = id else
        {
            //its a local trail report
            return
        }
        let url = URL(string: "\(baseURL)/api/trail-reports/\(id)")!
                
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response.suggestedFilename ?? "ahhh")
            } else
            {
                print("Bad JSON received back")
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
            polylineRenderer.lineWidth = 3.0
            
            return polylineRenderer
        }
        return tileRenderer
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if !(cancelTrailReportView.isHidden)
        {
            selectedTrailReport = nil
            selectedTrailReportAnnotation = nil
            cancelTrailReportView.isHidden = true
        }
        
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
            selectedTrailReport = trailReports?.first(where: {$0.id == annotation.id})
            selectedTrailReportAnnotation = annotation
            cancelTrailReportView.isHidden = false
            return
        }
        if Self.routeInProgress
        {
            //then there is already a route in progress and they must cancel the route before selecting another destination
            return
        }
            Self.origin = nil
            Self.wasSelectedWithOrigin = false
            Self.destination = view.annotation as? ImageAnnotation
            sampleRoute()
    }
}

extension InteractiveMapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrailReportTypeTableViewCell", for: indexPath) as? TrailReportTypeTableViewCell else {fatalError("Unable to deque cell")}
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
        else if (cell.lbl.text == "Thin Cover")
        {
            createTrailReport(type: .thinCover)
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
        if textField == searchBar.destinationTextField
        {
            Self.didChooseDestination = false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if Self.wasCancelled
        {
            dismissSideMenu()
            return
        }
        if self.searchBar.originTextField.text!.isEmpty && textField == searchBar.originTextField
        {
            Self.origin = nil
        }
        else if (textField == searchBar.originTextField)
        {
            guard let firstCell = self.trailSelectorView!.searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrailSelectorTableViewCell else
            {
                //then there are no trails matching the search text
                return
            }
            Self.origin = firstCell.cellTrail!
            Self.wasSelectedWithOrigin = true
            self.searchBar.originTextField.text = firstCell.cellTrail?.title!
        }
        if textField == searchBar.destinationTextField && !(self.searchBar.destinationTextField.text!.isEmpty) && !Self.didChooseDestination
        {
            guard let firstCell = self.trailSelectorView!.searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrailSelectorTableViewCell else {
                //Then there are not trails matching the search text
                return
            }
            self.searchBar.destinationTextField.text = firstCell.cellTrail?.title
            Self.destination = firstCell.cellTrail
            self.trailSelectorMenu?.dismissItems()
            self.trailSelectorView?.isPresented = false
            self.searchBar.destinationTextField.text = nil
            self.reloadButtons()
            self.sampleRoute()
            self.searchBar.originTextField.text = nil
        }
        else if (textField == searchBar.destinationTextField && !Self.didChooseDestination)
        {
            Self.destination = nil
        }
    }
}

extension InteractiveMapViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if Self.routeInProgress && canFindPathAgain && !Self.wasSelectedWithOrigin
        {
            Self.origin = nil
            canFindPathAgain = false
            displayRoute()
        }
        
        guard let currentUserId = Self.currentUser?.id else
        {
            return
        }
        saveUserLocation(UserLocation(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude, timeReported: "\(locations[0].timestamp)", userID: currentUserId))
    }
}

