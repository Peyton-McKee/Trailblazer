//
//  InteractiveMapViewController.swift
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
    @ObservedObject var connectivityController = ConnectivityController.shared
    
    static var currentUser : User = User(username: "Guest", password: "", alertSettings: [], routingPreference: "")
    static var initialRegion : MKCoordinateRegion?
    static var mapId: String = {
        if let str = UserDefaults.standard.value(forKey: "mapId") as? String {
            return str
        }
        return ""
    }()
    
    static var trailReports : [TrailReport] = []
    
    var routeInProgress = false
    
    var configuredClasses = false
    var wasCancelled = false
    
    lazy var selectedGraph = self.preferredRoutingGraph
    var baseLiftVertexes: [Vertex<ImageAnnotation>] = []
    
    lazy var preferredRoutingGraph : EdgeWeightedDigraph<ImageAnnotation> = {
        return self.getDefaultPreferredGraph()
    }()
    
    var wasSelectedWithOrigin = false
    var didChooseDestination = false
    
        
    lazy var loadingScreen : LoadingView = {
        var view = LoadingView(frame: self.view.frame)
        view.isHidden = true
        return view
    }()
    
    var isWaitingInLine = false
    var selectedTrailReport : TrailReport?
    var selectedTrailReportAnnotation : ImageAnnotation?
    
    var cancelTrailReportView = CancelTrailReportView()
    
    var gestureTimer = Date()
    
    var allTrailMapView = MKMapView()
    
    var canFindPathAgain = true
    var isRealTimeGraph = false
    var toggleGraphButton = UIButton()
    var followingRoute = false
    
    var initialLocation : String?
    var timer = Date()
    var myMap = MKMapView()
    var tileRenderer: MKTileOverlayRenderer!
    var myPolyLine = CustomPolyline()
    
    var cancelButton = UIButton()
    var cancelButtonYContraint = NSLayoutConstraint()
    
    lazy var searchBar : SearchBarTableHeaderView = {
        let searchBar = SearchBarTableHeaderView(frame: self.view.bounds, extendedFrame: CGRect(x: 20, y: 40, width: view.bounds.width - 36, height: 40), droppedDownFrame: CGRect(x: 20, y: 40, width: view.bounds.width - 36, height: 80))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.destinationTextField.delegate = self
        searchBar.originTextField.delegate = self
        searchBar.directionsButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
        searchBar.directionsButton.addTarget(self, action: #selector(moveTrailSelectorView), for: .touchUpInside)
        searchBar.searchButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
        searchBar.searchButton.addTarget(self, action: #selector(dismissSideMenu), for: .touchUpInside)
        return searchBar
    }()
    
    var pathCreated: [Vertex<ImageAnnotation>] = []
    
    let settingArray = [TrailReportType.moguls.rawValue, TrailReportType.ice.rawValue, TrailReportType.crowded.rawValue, TrailReportType.thinCover.rawValue, TrailReportType.longLiftLine.rawValue, TrailReportType.snowmaking.rawValue, "Cancel"]
    
    lazy var trailReportMenu : PopUpMenuFramework = {
        let trailReportMenu = PopUpMenuFramework(vc: self, height: 300)
        trailReportMenu.view = trailReportTableView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTrailReportMenu))
        trailReportMenu.transparentView.addGestureRecognizer(dismissTapGesture)
        return trailReportMenu
    }()
    
    var trailReportTableView = UITableView()
    
    let locationManager = LocationManager()
    
    lazy var routeOverviewMenu : PopUpMenuFramework = {
        let routeOverviewMenu = PopUpMenuFramework(vc: self, height: 300)
        routeOverviewMenu.view = self.routeOverviewView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissRouteOverviewMenu))
        routeOverviewMenu.transparentView.addGestureRecognizer(dismissTapGesture)
        return routeOverviewMenu
    }()
    
    lazy var routeOverviewView : RouteOverviewView = {
        let routeOverviewView = RouteOverviewView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200))
        routeOverviewView.viewFullDirectionsButton.addTarget(self, action: #selector(presentFullDirections), for: .touchUpInside)
        routeOverviewView.letsGoButton.addTarget(self, action: #selector(letsGoButtonPressed), for: .touchUpInside)
        return routeOverviewView
    }()
    
    var trailReportAnnotation = ImageAnnotation()
    
    lazy var mapLoadingView = RetrievingMapLoadingView(frame: self.view.frame)
    
    lazy var trailSelectorView = TrailSelectorView(vc: self)
    lazy var trailSelectorMenu = SideMenuFramework(vc: self)
    
    var recenterButton = UIButton()
    var recenterButtonYConstraint = NSLayoutConstraint()
    
    var previousClosestAnnotation : Vertex<ImageAnnotation>?
    
    var originTextFieldTrail : ImageAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTrailReportView()
        configureMyMap()
        self.view.addSubview(searchBar)
        checkUserDefaults()
        configureButtons()
        locationManager.locationManager.delegate = self
        locationManager.locationManager.requestWhenInUseAuthorization()
        locationManager.locationManager.startUpdatingHeading()
        locationManager.locationManager.startUpdatingLocation()
        self.view.addSubview(mapLoadingView)
        self.view.addSubview(loadingScreen)
        mapLoadingView.isHidden = false
        MapInterpreter.shared.getMap(id: Self.mapId)
        self.tabBarController?.tabBar.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("cancelRoute"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(selectGraph), name: Notification.Name(rawValue: "selectGraph"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(trailSelectorView.reloadMyTrails), name: Notification.Name("configureTrailSelector"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createNotification), name: Notification.Name("createNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateInitialRegion(_:)), name: Notification.Name("updateInitialRegion"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelRoute), name: Notification.Name("cancelRoute"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePreferredGraph), name: Notification.Name("updateRoutingPreference"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "selectGraph"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("configureTrailSelector"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("createNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updateInitialRegion"), object: nil)
    }
    
    @objc private func createNotification(sender: NSNotification)
    {
        guard let trailReport = sender.userInfo?["report"] as? TrailReport else
        {
            print("NotiAnnotation configured incorrectly or does not exist")
            return
        }
        locationManager.makeTrailReportRegion(trailReport: trailReport)
        locationManager.registerNotification(title: "CAUTION: \(trailReport.type.uppercased()) AHEAD", body: trailReport.type, trailReportID: trailReport.id!)
    }
    
    func getDefaultPreferredGraph() -> EdgeWeightedDigraph<ImageAnnotation>
    {
        guard let defaultGraph = UserDefaults.standard.string(forKey: "routingPreference") else
        {
            return MapInterpreter.shared.difficultyGraph
        }
        switch defaultGraph{
        case RoutingType.leastDistance.rawValue:
            return MapInterpreter.shared.distanceGraph
        case RoutingType.quickest.rawValue:
            return MapInterpreter.shared.timeGraph
        default:
            return MapInterpreter.shared.difficultyGraph
        }
    }
    
    @objc func updatePreferredGraph(sender: NSNotification) {
        guard let preference = sender.userInfo?["preference"] as? EdgeWeightedDigraph<ImageAnnotation> else {
            return
        }
        self.preferredRoutingGraph = preference
    }
    
    @objc func updateInitialRegion(_ sender: NSNotification)
    {
        guard let latitude = sender.userInfo?["initialRegionLatitude"] as? Double, let longitude = sender.userInfo?["initialRegionLongitude"] as? Double, let trailReports = sender.userInfo?["trailReports"] as? [TrailReport] else { return }
        Self.initialRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
        Self.trailReports = trailReports
        myMap.region = Self.initialRegion!
        myMap.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: Self.initialRegion!)
        myMap.setCamera(MKMapCamera(lookingAtCenter: Self.initialRegion!.center, fromDistance: CLLocationDistance(10000), pitch: 0, heading: CLLocationDirection(360)), animated: true)
        mapLoadingView.isHidden = true
    }
    
    @objc func removeTrailReport(sender: UIButton)
    {
        let annotation = self.selectedGraph.vertices.first(where: {$0.value.trailReport == selectedTrailReportAnnotation})
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
    
    @objc func toggleGraph()
    {
        if self.routeInProgress
        {
            cancelRoute()
        }
        if isRealTimeGraph {
            self.selectedGraph = self.preferredRoutingGraph
        }
        else
        {
            self.selectedGraph = WebAnalysis.shared.realTimeGraph
        }
        trailSelectorView.reloadMyTrails()
        isRealTimeGraph.toggle()
        showAllTrails()
    }
    
    @objc func selectGraph()
    {
        showAllTrails()
    }
    
    @objc func cancelRoute()
    {
        print("cancelling route")
        self.initialLocation = nil
        self.routeInProgress = false
        self.pathCreated = []
        self.trailSelectorView.isPresented = false
        self.cancelButton.isHidden = true
        while self.selectedGraph.vertices.last?.value.title! == "Your Location"{
            print("test")
            self.selectedGraph.removeLastVertex()
        }
        connectivityController.setRoute(route: [])
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
            print("user: \(user)")
            Self.currentUser = user
        })
    }
    
    
    @objc func dismissSideMenu()
    {
        if trailSelectorView.isPresented
        {
            self.trailSelectorMenu.dismissItems()
            self.trailSelectorView.isPresented = false
            self.searchBar.destinationTextField.text = nil
            self.searchBar.originTextField.text = nil
            self.wasCancelled = false
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
    
    
    @objc func updateSelectedGraphAndShowAllTrails()
    {
        self.configureTrailReportView()
        self.preferredRoutingGraph = self.getDefaultPreferredGraph()
        self.selectedGraph = self.preferredRoutingGraph
        self.showAllTrails()
        DispatchQueue.main.async{
            WebAnalysis.shared.makeRequest(graph: self.selectedGraph)
        }
    }
    
    @objc func presentSideMenu()
    {
        if searchBar.isDroppedDown
        {
            self.trailSelectorView.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 120, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu.presentDroppedDownItems()
        }
        else
        {
            self.trailSelectorView.frame = CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 80, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            trailSelectorMenu.presentItems()
        }
        trailSelectorView.isPresented = true
    }
    
    func selectedTrail(origin: ImageAnnotation?, destination: ImageAnnotation)
    {
        self.searchBar.destinationTextField.text = nil
        self.searchBar.originTextField.text = nil
        self.searchBar.isDroppedDown = false
        self.trailSelectorView.isPresented = false
        trailSelectorMenu.dismissItems()
        self.reloadButtons()
        sampleRoute(origin: origin, destination: destination)
    }
    
    func displayCurrentTrailReports(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        myMap.addAnnotations(graph.vertices.map({ $0.value }).filter({ $0.trailReport != nil }).map({ $0.trailReport! }))
    }
    
    
    /// createConstraints: UIView, Double, Double -> void
    ///@param::
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
    func getClosestAnnotation(origin: ImageAnnotation) -> Vertex<ImageAnnotation>
    {
        if self.selectedGraph.vertices.last == Vertex<ImageAnnotation>(origin)
        {
            self.selectedGraph.removeLastVertex()
        }
        var closestAnnotation = self.selectedGraph.vertices[0]
        for annotation in self.selectedGraph.vertices
        {
            if(sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < (sqrt(pow(closestAnnotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + (pow(closestAnnotation.value.coordinate.longitude - origin.coordinate.longitude, 2)))))
            {
                closestAnnotation = annotation
            }
        }
        return closestAnnotation
    }
    
    
    /// showAllTrails: void -> void
    /// Shows all the trails on the map
    private func showAllTrails()
    {
        myMap.removeOverlays(myMap.overlays)
        myMap.removeAnnotations(myMap.annotations)
        if self.isRealTimeGraph{
            myMap.addOverlays(WebAnalysis.shared.mapView.overlays)
            myMap.addAnnotations(WebAnalysis.shared.mapView.annotations)
        }
        else{
            myMap.addOverlays(MapInterpreter.shared.mapView.overlays)
            myMap.addAnnotations(MapInterpreter.shared.mapView.annotations)
        }
    }
    
    /// addTrailReport: Presents the trail report menu when the user holds down on a spot on the map
    ///
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
    /// Presents the Trail Report Menu
    private func presentTrailReportMenu()
    {
        trailReportTableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 250)
        trailReportMenu.presentItems()
    }
    
    /// dismissMenu: void -> void
    /// dismisses the Trail Report Menu
    @objc func dismissTrailReportMenu() {
        trailReportMenu.dismissItems()
    }
    
    /// dismissRouteOverviewMenu: void -> void
    /// dismisses the route overview menu and cancels any on going routes
    @objc func dismissRouteOverviewMenu()
    {
        cancelRoute()
        viewDidAppear(true)
        self.routeOverviewMenu.dismissItems()
    }
    
    /// letsGoButtonPressed: void -> void
    /// dismisses the route overview menu
    @objc func letsGoButtonPressed()
    {
        self.routeOverviewMenu.dismissItems()
        self.cancelButton.isHidden = false
        
        recenter()
        
        guard (Self.currentUser.id) != nil else{return}
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
            originAnnotation.subtitle = TrailReportType.moguls.rawValue
        case .ice:
            originAnnotation.subtitle = TrailReportType.ice.rawValue
        case .crowded:
            originAnnotation.subtitle = TrailReportType.crowded.rawValue
        case .thinCover:
            originAnnotation.subtitle = TrailReportType.thinCover.rawValue
        case .longLiftLine:
            originAnnotation.subtitle = TrailReportType.longLiftLine.rawValue
        case .snowmaking:
            originAnnotation.subtitle = TrailReportType.snowmaking.rawValue
        }
        guard let currentUserId = Self.currentUser.id else { return }
        saveTrailReporrt(TrailReport(type: originAnnotation.subtitle!, latitude: originAnnotation.coordinate.latitude, longitude: originAnnotation.coordinate.longitude, dateMade: "\(Date.now)", trailMadeOn: closestTrail.title!, userID: "\(currentUserId)"))
        closestTrail.trailReport = originAnnotation
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
            polylineRenderer.lineWidth = 3.0
            
            return polylineRenderer
        }
        return tileRenderer
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if(view.annotation?.title! == nil)
        {
            cancelTrailReportView.isHidden = true
        }
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
            selectedTrailReport = Self.trailReports.first(where: {$0.id == annotation.id})
            selectedTrailReportAnnotation = annotation
            cancelTrailReportView.isHidden = false
            return
        }
        if self.routeInProgress
        {
            //then there is already a route in progress and they must cancel the route before selecting another destination
            return
        }
        sampleRoute(origin: nil, destination: view.annotation as! ImageAnnotation)
    }
}

extension InteractiveMapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrailReportTypeTableViewCell", for: indexPath) as? TrailReportTypeTableViewCell else {fatalError("Unable to deque cell")}
        cell.lbl.text = settingArray[indexPath.row]
        if(settingArray[indexPath.row] == TrailReportType.moguls.rawValue)
        {
            cell.settingImage.image = UIImage(named: "MogulSquare.png")!
        }
        else if (settingArray[indexPath.row] == TrailReportType.ice.rawValue)
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
        switch cell.lbl.text{
        case TrailReportType.moguls.rawValue:
            createTrailReport(type: .moguls)
        case TrailReportType.ice.rawValue:
            createTrailReport(type: .ice)
        case TrailReportType.crowded.rawValue:
            createTrailReport(type: .crowded)
        case TrailReportType.thinCover.rawValue:
            createTrailReport(type: .thinCover)
        case TrailReportType.longLiftLine.rawValue:
            createTrailReport(type: .longLiftLine)
        case TrailReportType.snowmaking.rawValue:
            createTrailReport(type: .snowmaking)
        default:
            dismissTrailReportMenu()
        }
    }
}

extension InteractiveMapViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        trailSelectorView.currentTextField = textField
        if textField.placeholder == "Origin: Your Location..."
        {
            trailSelectorView.currentTextFieldType = .origin
        }
        else {
            trailSelectorView.currentTextFieldType = .destination
        }
        if(trailSelectorView.isPresented)
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
        if self.wasCancelled
        {
            dismissSideMenu()
            return
        }
        else if (textField == searchBar.originTextField)
        {
            guard let firstCell = self.trailSelectorView.searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrailSelectorTableViewCell else
            {
                //then there are no trails matching the search text
                return
            }
            self.originTextFieldTrail = firstCell.cellTrail!
            self.searchBar.originTextField.text = firstCell.cellTrail?.title!
        }
        if textField == searchBar.destinationTextField && !(self.searchBar.destinationTextField.text!.isEmpty)
        {
            guard let firstCell = self.trailSelectorView.searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrailSelectorTableViewCell else {
                //Then there are not trails matching the search text
                return
            }
            self.searchBar.destinationTextField.text = firstCell.cellTrail?.title
            self.trailSelectorMenu.dismissItems()
            self.trailSelectorView.isPresented = false
            self.reloadButtons()
            self.sampleRoute(origin: self.originTextFieldTrail, destination: firstCell.cellTrail!)
            self.originTextFieldTrail = nil
            self.searchBar.originTextField.text = nil
            self.searchBar.destinationTextField.text = nil
        }
    }
}


