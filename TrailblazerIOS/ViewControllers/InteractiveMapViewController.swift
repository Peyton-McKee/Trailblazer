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
    
    var cancelButton = UIButton()
    var cancelButtonYContraint = NSLayoutConstraint()
    
    var pathCreated: [Vertex<ImageAnnotation>] = []
    
    let settingArray = [TrailReportType.moguls.rawValue, TrailReportType.ice.rawValue, TrailReportType.crowded.rawValue, TrailReportType.thinCover.rawValue, TrailReportType.longLiftLine.rawValue, TrailReportType.snowmaking.rawValue, "Cancel"]
    
    lazy var trailReportMenu : PopUpMenuFramework = {
        let trailReportMenu = PopUpMenuFramework(vc: self, height: 300)
        trailReportMenu.view = trailReportTableView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissTrailReportMenu))
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
    
    lazy var trailReportTableView : UITableView = {
        let trailReportTableView = UITableView()
        trailReportTableView.isScrollEnabled = true
        trailReportTableView.layer.cornerRadius = 15
        trailReportTableView.delegate = self
        trailReportTableView.dataSource = self
        trailReportTableView.register(TrailReportTypeTableViewCell.self, forCellReuseIdentifier: "TrailReportTypeTableViewCell")
        return trailReportTableView
    }()

    lazy var routeOverviewMenu : PopUpMenuFramework = {
        let routeOverviewMenu = PopUpMenuFramework(vc: self, height: 300)
        routeOverviewMenu.view = self.routeOverviewView
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissRouteOverviewMenu))
        routeOverviewMenu.transparentView.addGestureRecognizer(dismissTapGesture)
        return routeOverviewMenu
    }()
    
    lazy var routeOverviewView : RouteOverviewView = {
        let routeOverviewView = RouteOverviewView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 200))
        routeOverviewView.viewFullDirectionsButton.addTarget(self, action: #selector(self.presentFullDirections), for: .touchUpInside)
        routeOverviewView.letsGoButton.addTarget(self, action: #selector(self.letsGoButtonPressed), for: .touchUpInside)
        return routeOverviewView
    }()
    
    lazy var directionsView : DirectionsView = {
        let directionsView = DirectionsView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100))
        directionsView.isHidden = true
        return directionsView
    }()
    
    lazy var totalDirectionsView : FullDirectionView = {
        let view = FullDirectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.9))
        view.closeButton.addTarget(self, action: #selector(self.closeFullDirections), for: .touchUpInside)
        return view
    }()
    
    
    lazy var mapLoadingView = RetrievingMapLoadingView(frame: self.view.frame)
    
    lazy var trailSelectorView = TrailSelectorView(frame: self.view.frame, vertices: self.selectedGraph.vertices, selectedTrail: self.selectedTrail)

    lazy var trailSelectorMenu : SideMenuFramework = {
        let trailSelectorMenu = SideMenuFramework(vc: self)
        trailSelectorMenu.view = trailSelectorView
        return trailSelectorMenu
    }()
    
    lazy var interactiveMapView = InteractiveMapView(vc: self)
    
    var trailReportAnnotation = ImageAnnotation()

    var recenterButton = UIButton()
    var recenterButtonYConstraint = NSLayoutConstraint()
    
    var previousClosestAnnotation : Vertex<ImageAnnotation>?
    
    var originTextFieldTrail : ImageAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.checkUserDefaults()
        LocationManager.shared.delegate = self
        LocationManager.shared.requestWhenInUseAuthorization()
        LocationManager.shared.startUpdatingHeading()
        LocationManager.shared.startUpdatingLocation()
        self.view.addSubview(self.interactiveMapView)
        self.view.addSubview(self.searchBar)
        self.configureButtons()
        self.view.addSubview(self.loadingScreen)
        self.view.addSubview(self.mapLoadingView)
        self.view.addSubview(self.directionsView)
        self.view.addSubview(self.totalDirectionsView)
        self.totalDirectionsView.isHidden = true
        self.mapLoadingView.isHidden = false
        self.getMap(id: Self.mapId)
        self.tabBarController?.tabBar.backgroundColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Names.createNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.Names.updateInitialRegion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createNotification), name: Notification.Name.Names.createNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDataFromMapInterpreter), name: Notification.Name.Names.updateInitialRegion, object: nil)
    }
    
    deinit {
        self.cancelRoute()
        print("deallocating interactive map view controller")
    }
    
    private func checkUserDefaults() {
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

    @objc func receiveDataFromMapInterpreter(_ sender: NSNotification) {
        guard let latitude = sender.userInfo?["initialRegionLatitude"] as? Double, let longitude = sender.userInfo?["initialRegionLongitude"] as? Double, let trailReports = sender.userInfo?["trailReports"] as? [TrailReport] else { return }
        let initialRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
        Self.trailReports = trailReports
        self.interactiveMapView.setBoundaryAround(region: initialRegion)
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
        self.interactiveMapView.removeOverlays(self.interactiveMapView.overlays)
        self.interactiveMapView.removeAnnotations(self.interactiveMapView.annotations)
        if self.isRealTimeGraph {
            self.interactiveMapView.addOverlays(WebAnalysis.shared.mapView.overlays)
            self.interactiveMapView.addAnnotations(WebAnalysis.shared.mapView.annotations)
        }
        else {
            self.interactiveMapView.addOverlays(MapInterpreter.shared.mapView.overlays)
            self.interactiveMapView.addAnnotations(MapInterpreter.shared.mapView.annotations)
        }
    }
    
    /// getClosestAnnotation: ImageAnnotation -> Vertex<ImageAnnotation>
    /// paramaters:
    ///     - origin: The annotation you want to find the nearest annotation for
    /// Finds the annotation the least distacne from the passed in origin
    func getClosestAnnotation(origin: ImageAnnotation) throws -> Vertex<ImageAnnotation> {
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
        if(self.searchBar.isDroppedDown || self.routeInProgress)
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
    
    private func getMap(id: String)
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
