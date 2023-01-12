//
//  Web Analysis.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/23/22.
//
//
//import Foundation

//
//  ViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import UIKit
import UserNotifications
import WebKit
import MapKit

struct TrailData{
    var trails: [String] = []
    var lifts: [String] = []
}
final class WebAnalysis: NSObject, WKNavigationDelegate {
    var mapView = MKMapView()
    static let shared = WebAnalysis()
    var realTimeGraph = EdgeWeightedDigraph<ImageAnnotation>()
    let webView = WKWebView(frame: .zero)
    let trailNames : [String] = InteractiveMapViewController.selectedGraph.vertices.filter({$0.value.difficulty != .lift}).map({$0.value.title!})
    let liftNames : [String] = InteractiveMapViewController.selectedGraph.vertices.filter({$0.value.difficulty == .lift}).map({$0.value.title!})
    lazy var individualTrailNames : [String] = {
        var found : [String] = []
        for trail in self.trailNames
        {
            if !found.contains(trail)
            {
                found.append(trail)
            }
        }
        return found
    }()
    lazy var individualLiftNames : [String] = {
        var found : [String] = []
        for trail in self.liftNames
        {
            if !found.contains(trail)
            {
                found.append(trail)
            }
        }
        return found
    }()
    let urlRequest = URLRequest(url: URL(string: "https://www.sundayriver.com/mountain-report")!)
    func makeRequest()
    {
        webView.navigationDelegate = self
        
        webView.load(urlRequest)
        
    }
    
    func assignStatus(status: String, trail: [Vertex<ImageAnnotation>])
    {
        for annotation in trail
        {
            switch status{
            case "closed":
                annotation.value.status = .closed
            case "open":
                annotation.value.status = .open
            case "on hold":
                annotation.value.status = .onHold
            case "scheduled":
                annotation.value.status = .scheduled
            default:
                annotation.value.status = .event
            }
            //print("Assigning status: \(status) to Trail : \(annotation.value.title!)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        getMountainReport(webView: webView, queryItems: TrailData(trails: individualTrailNames, lifts: individualLiftNames), completion: { [self]
            value in
            switch value{
            case .success(let value):
                DispatchQueue.global().async { [self] in
                    for index in 0..<value.lifts.count
                    {
                        assignStatus(status: value.lifts[index], trail: InteractiveMapViewController.selectedGraph.vertices.filter({$0.value.title == individualLiftNames[index]}))
                    }
                    for index in 0..<value.trails.count
                    {
                        assignStatus(status: value.trails[index], trail: InteractiveMapViewController.selectedGraph.vertices.filter({$0.value.title == individualTrailNames[index]}))
                    }
                    var overlays : [CustomPolyline] = []
                    var annotations : [ImageAnnotation] = []
                    var foundTrails : [String] = []
                    for annotation in InteractiveMapViewController.selectedGraph.vertices
                    {
                        //print("\(annotation.value.title): \(annotation.value.status)")
                        if annotation.value.status == .open || annotation.value.status == .scheduled
                        {
                            realTimeGraph.addVertex(annotation)
                            if !foundTrails.contains(annotation.value.title!)
                            {
                                foundTrails.append(annotation.value.title!)
                                annotations.append(annotation.value)
                            }
                            for edge in annotation.adjacentEdges
                            {
                                let poly = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                                switch edge.source.value.difficulty{
                                case .easy:
                                    poly.color = .myTheme.easyColor
                                case .intermediate:
                                    poly.color = .myTheme.intermediateColor
                                case .advanced:
                                    poly.color = .myTheme.advancedColor
                                case .expertsOnly:
                                    poly.color = .myTheme.expertsOnlyColor
                                case .lift:
                                    poly.color = .myTheme.liftsColor
                                default:
                                    poly.color = .myTheme.terrainParksColor
                                }
                                overlays.append(poly)
                                if edge.destination.value.isConnector {
                                    edge.destination.value.status = .open
                                }
                                if edge.source.value.isConnector {
                                    edge.source.value.status = .open
                                }
                            }
                        }
                    }
                    print("Completed realTimeGraph with \(realTimeGraph.verticesCount()) vertices and \(realTimeGraph.edgesCount()) edges")
                    mapView.addOverlays(overlays)
                    mapView.addAnnotations(annotations)
                    //InteractiveMapViewController.selectedGraph = TrailsDatabase.realTimeGraph
                    //NotificationCenter.default.post(name: Notification.Name(rawValue: "selectGraph"), object: nil)
                }
            case .failure(let error):
                    print("failed to find data - \(error)")
            }
        })
    }

}


//    let liftNames = ["Barker Mountain Express #1", "South Ridge Express #2", "Quantum Leap Triple #3", "Locke Mountain Triple #4", /*"Alera Group Competition Lift #5",*/ "North Peak Express #6", "Chondola #7", "Spruce Peak Triple #8", "White Cap Quad #9", "White Heat Quad #10", "Little White Cap Quad #11", "Aurora Peak Quad #12", "Jordan Mountain Double #13", "Jordan Bowl Express #14", /*"OZ Quad #15"*/]
//    let whiteCapTrailNames = ["Salvation", "Heat's Off", "Obsession", "Chutzpah", "White Heat", "Shock Wave", "Upper Tempest", "Jibe", "Heat's On", "Green Cheese", "Upper Moonstruck", "Assumption", "Starlight", "Starstruck", "Starwood", "Starburst", "Bear Paw", "Wildfire", "Cutoff", "Snowbound"]
//    let lockeTrailNames = ["Goat Path", "Upper Cut", "Upper Sunday Punch", "Locke Line", "Jim's Whim", "T2", "Bim's Whim", "Cascades", "Road Runner", "Lower Upper Cut", "Sunday Punch", "Tightwire"]
//    let barkerTrailNames = ["Three Mile Trail", "Lazy River", "Sluice", "Right Stuff", "Agony", "Top Gun", "Ecstasy", "Jungle Road", "South Paw", "Rocking Chair", "Tourist Trap"]
//    let southRidgeNames = ["Ridge Run", "Broadway", "Lower Lazy River", "Thataway", "Mixing Bowl", "Lower Chondi Line", "Who-Ville", "Wonderland Park", "Northway", "Spectator", "Double Dipper", "Sundance"]
//    let spruceNames = ["Sirius", "Upper Downdraft", "American Express", "Upper Risky Business", "Gnarnia", "Lower Downdraft"]
//    let northPeakNames = ["Paradigm", "Second Mile", "Grand Rapids", "Dream Maker", "T72", "Sensation", "Dream Maker", "Escapade", "3D", "Second Thoughts"]
//    let auroraNames = ["Cyclone", "Northern Lights", "Witch Way", "Airglow", "Black Hole", "Firestar", "Lights Out", "Borealis", "Vortex", "Quantum Leap"]
//    let ozNames = ["Tin Woodsman", "Kansas"]
//
//    let jordanNames = ["Lollapalooza", "Excalibur", "Rogue Angel", "Caramba", "Blind Ambition"]
    
