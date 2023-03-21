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

class InteractiveMapViewController: UIViewController, ErrorHandler {
    @ObservedObject var connectivityController = ConnectivityController.shared
    
    static var currentUser : User = User(username: "Guest", password: "", alertSettings: [], routingPreference: "")
    static var mapId: String = {
        if let str = UserDefaults.standard.value(forKey: "mapId") as? String {
            return str
        }
        return ""
    }()
    
    static var trailReports : [TrailReport] = []
    
    var initialRegion : MKCoordinateRegion?

    var routeInProgress = false
    
    var wasCancelled = false
    
    var selectedGraph: EdgeWeightedDigraph<ImageAnnotation> {
        return self.isRealTimeGraph ? WebAnalysis.shared.realTimeGraph : self.preferredRoutingGraph
    }
    
    var baseLiftVertexes: [Vertex<ImageAnnotation>] = []
    
    var preferredRoutingGraph : EdgeWeightedDigraph<ImageAnnotation> {
        return self.getPreferredGraph()
    }
    
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
    
    var cancelButton = UIButton()
    var cancelButtonYContraint = NSLayoutConstraint()
    
    var pathCreated: [Vertex<ImageAnnotation>] = []
    
    let settingArray = [TrailReportType.moguls.rawValue, TrailReportType.ice.rawValue, TrailReportType.crowded.rawValue, TrailReportType.thinCover.rawValue, TrailReportType.longLiftLine.rawValue, TrailReportType.snowmaking.rawValue, "Cancel"]
    
    lazy var trailReportMenu : PopUpMenuFramework = {
        let trailReportMenu = PopUpMenuFramework(vc: self, height: 300)
        trailReportMenu.view = trailReportTableView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissTrailReportMenu))
        trailReportMenu.transparentView.addGestureRecognizer(dismissTapGesture)
        return trailReportMenu
    }()
    
    lazy var searchBar : SearchBarTableHeaderView = {
        let searchBar = SearchBarTableHeaderView(frame: CGRect(x: 20, y: 40, width: 40, height: 40), extendedFrame: CGRect(x: 20, y: 40, width: self.view.bounds.width - 36, height: 40), droppedDownFrame: CGRect(x: 20, y: 40, width: view.bounds.width - 36, height: 80))
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.destinationTextField.delegate = self
        searchBar.originTextField.delegate = self
        searchBar.directionsButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
        searchBar.directionsButton.addTarget(self, action: #selector(moveTrailSelectorView), for: .touchUpInside)
        searchBar.searchButton.addTarget(self, action: #selector(reloadButtons), for: .touchUpInside)
        searchBar.searchButton.addTarget(self, action: #selector(dismissSideMenu), for: .touchUpInside)
        return searchBar
    }()
    
    var trailReportTableView = UITableView()

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
    
    
    lazy var mapLoadingView = RetrievingMapLoadingView(frame: self.view.frame)
    
    lazy var trailSelectorView = TrailSelectorView(vc: self)

    lazy var trailSelectorMenu : SideMenuFramework = {
        let trailSelectorMenu = SideMenuFramework(vc: self)
        trailSelectorMenu.view = trailSelectorView
        return trailSelectorMenu
    }()
    
    var trailReportAnnotation = ImageAnnotation()

    var recenterButton = UIButton()
    var recenterButtonYConstraint = NSLayoutConstraint()
    
    var previousClosestAnnotation : Vertex<ImageAnnotation>?
    
    var originTextFieldTrail : ImageAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configureTrailReportView()
        self.configureMyMap()
        self.checkUserDefaults()
        self.configureButtons()
        LocationManager.shared.delegate = self
        LocationManager.shared.requestWhenInUseAuthorization()
        LocationManager.shared.startUpdatingHeading()
        LocationManager.shared.startUpdatingLocation()
        self.view.addSubview(searchBar)
        self.view.addSubview(loadingScreen)
        self.view.addSubview(mapLoadingView)
        self.mapLoadingView.isHidden = false
        self.getMap(id: Self.mapId)
        self.tabBarController?.tabBar.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Names.createNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Names.updateInitialRegion, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Names.cancelRoute, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Names.updateRoutingPreference, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createNotification), name: Notification.Name.Names.createNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDataFromMapInterpreter), name: Notification.Name.Names.updateInitialRegion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelRoute), name: Notification.Name.Names.cancelRoute, object: nil)
    }
    
    deinit {
        print("deallocating interactive map view controller")
    }
    
    private func checkUserDefaults()
    {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return
        }

        APIHandler.shared.getSingleUser(id: userId, completion: { result in
            do {
                let user = try result.get()
                Self.currentUser = user
            } catch {
                DispatchQueue.main.async {
                    self.handle(error: error)
                }
                return
            }
        })
    }

    @objc func receiveDataFromMapInterpreter(_ sender: NSNotification)
    {
        guard let latitude = sender.userInfo?["initialRegionLatitude"] as? Double, let longitude = sender.userInfo?["initialRegionLongitude"] as? Double, let trailReports = sender.userInfo?["trailReports"] as? [TrailReport] else { return }
        self.initialRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
        Self.trailReports = trailReports
        self.myMap.region = self.initialRegion!
        self.myMap.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: self.initialRegion!)
        self.myMap.setCamera(MKMapCamera(lookingAtCenter: self.initialRegion!.center, fromDistance: CLLocationDistance(10000), pitch: 0, heading: CLLocationDirection(360)), animated: true)
        self.updateSelectedGraphAndShowAllTrails()
        self.mapLoadingView.isHidden = true
        DispatchQueue.main.async{
            self.showAllTrails()
            WebAnalysis.shared.makeRequest(graph: self.selectedGraph)
        }
    }
    
    func selectedTrail(origin: ImageAnnotation?, destination: ImageAnnotation)
    {
        self.searchBar.destinationTextField.text = nil
        self.searchBar.originTextField.text = nil
        self.searchBar.isDroppedDown = false
        self.trailSelectorView.isPresented = false
        self.routeInProgress = false
        self.trailSelectorMenu.dismissItems()
        self.reloadButtons()
        self.sampleRoute(origin: origin, destination: destination)
    }

    /// showAllTrails: void -> void
    /// Shows all the trails on the map
    func showAllTrails()
    {
        self.myMap.removeOverlays(self.myMap.overlays)
        self.myMap.removeAnnotations(self.myMap.annotations)
        if self.isRealTimeGraph{
            self.myMap.addOverlays(WebAnalysis.shared.mapView.overlays)
            self.myMap.addAnnotations(WebAnalysis.shared.mapView.annotations)
        }
        else{
            self.myMap.addOverlays(MapInterpreter.shared.mapView.overlays)
            self.myMap.addAnnotations(MapInterpreter.shared.mapView.annotations)
        }
    }
    
    /// getClosestAnnotation: ImageAnnotation -> Vertex<ImageAnnotation>
    /// paramaters:
    ///     - origin: The annotation you want to find the nearest annotation for
    /// Finds the annotation the least distacne from the passed in origin
    func getClosestAnnotation(origin: ImageAnnotation) throws -> Vertex<ImageAnnotation>
    {
        self.selectedGraph.removeVertices({$0.value.title == "Your Location"})
        guard var closestAnnotation = self.selectedGraph.vertices.first else {
            throw GraphErrors.selectedGraphHasNoVerticesError
        }
        for annotation in self.selectedGraph.vertices
        {
            if(sqrt(pow(annotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + pow(annotation.value.coordinate.longitude - origin.coordinate.longitude, 2)) < (sqrt(pow(closestAnnotation.value.coordinate.latitude - origin.coordinate.latitude, 2) + (pow(closestAnnotation.value.coordinate.longitude - origin.coordinate.longitude, 2))))) {
                closestAnnotation = annotation
            }
        }
        return closestAnnotation
    }
    
    @objc func reloadButtons()
    {
        if(self.searchBar.isDroppedDown)
        {
            self.recenterButtonYConstraint.constant = 120
            self.cancelButtonYContraint.constant = 120
        }
        else
        {
            self.recenterButtonYConstraint.constant = 80
            self.cancelButtonYContraint.constant = 80
        }
        self.animateLayoutChange()
    }
    
    private func animateLayoutChange()
    {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func getMap(id: String)
    {
        APIHandler.shared.getMap(id: id, completion: {
            result in
            do {
                let map = try result.get()
                DispatchQueue.main.async {
                    MapInterpreter.shared.createMap(map: map)
                }
            } catch {
                DispatchQueue.main.async {
                    self.handle(error: error)
                }
            }
        })
    }
}
