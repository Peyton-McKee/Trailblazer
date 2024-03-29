//
//  Web Analysis.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/23/22.
//
//
//import Foundation

import UIKit
import UserNotifications
import WebKit
import MapKit

struct TrailData {
    var trails: [String] = []
    var lifts: [String] = []
}

final class WebAnalysis: NSObject, WKNavigationDelegate {
    static let shared = WebAnalysis()
    var mapView = MKMapView()
    var realTimeGraph = EdgeWeightedDigraph<ImageAnnotation>()
    let webView = WKWebView(frame: .zero)
    var trailStatusElementId: String?
    var liftStatusElementId: String?
    var graph: EdgeWeightedDigraph<ImageAnnotation>?
    
    func makeRequest(graph: EdgeWeightedDigraph<ImageAnnotation>)
    {
        self.realTimeGraph = EdgeWeightedDigraph<ImageAnnotation>()
        
        APIHandler.shared.getMap(id: InteractiveMapViewController.mapId, completion: {
            result in
            guard let map = try? result.get() else {
                print("Failed to get map: \(result)")
                return
            }
            guard let mountainReportUrl = map.mountainReportUrl else {
                print("Error: Map has no mountain report URL!")
                return
            }
            DispatchQueue.main.async {
                self.trailStatusElementId = map.trailStatusElementId
                self.liftStatusElementId = map.liftStatusElementId
                self.graph = graph
                self.webView.navigationDelegate = self
                let urlRequest = URLRequest(url: URL(string: mountainReportUrl)!)
                self.webView.load(urlRequest)
            }
        })
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
        guard let trailStatusElementId = self.trailStatusElementId, let liftStatusElementId = self.liftStatusElementId, let graph = self.graph else {
            print("Error: Map Does Not Have Trail Elment Id or Lift Element Id!")
            return
        }
        let trailNames : [String] = graph.vertices.filter({$0.value.difficulty != .lift}).map({$0.value.title!})
        let liftNames : [String] = graph.vertices.filter({$0.value.difficulty == .lift}).map({$0.value.title!})
        let individualTrailNames : [String] = {
            var found : [String] = []
            for trail in trailNames
            {
                if !found.contains(trail)
                {
                    found.append(trail)
                }
            }
            return found
        }()
        let individualLiftNames : [String] = {
            var found : [String] = []
            for trail in liftNames
            {
                if !found.contains(trail)
                {
                    found.append(trail)
                }
            }
            return found
        }()
        
        self.getMountainReport(webView: webView, queryItems: TrailData(trails: individualTrailNames, lifts: individualLiftNames), liftStatusId: liftStatusElementId, trailStatusId: trailStatusElementId, completion: { [self]
            value in
            switch value{
            case .success(let value):
                DispatchQueue.global().async { [self] in
                    for index in 0..<value.lifts.count
                    {
                        assignStatus(status: value.lifts[index], trail: graph.vertices.filter({$0.value.title == individualLiftNames[index]}))
                    }
                    for index in 0..<value.trails.count
                    {
                        assignStatus(status: value.trails[index], trail: graph.vertices.filter({$0.value.title == individualTrailNames[index]}))
                    }
                    var overlays : [CustomPolyline] = []
                    var annotations : [ImageAnnotation] = []
                    var foundTrails : [String] = []
                    for vertex in graph.vertices
                    {
                        //print("\(annotation.value.title): \(annotation.value.status)")
                        if vertex.value.status == .open || vertex.value.status == .scheduled
                        {
                            realTimeGraph.addVertex(vertex)
                            if !foundTrails.contains(vertex.value.title!)
                            {
                                foundTrails.append(vertex.value.title!)
                                annotations.append(vertex.value)
                            }
                            if let trailReport = vertex.value.trailReport {
                                annotations.append(trailReport)
                            }
                            for edge in vertex.adjacentEdges
                            {
                                let poly = CustomPolyline(coordinates: [edge.source.value.coordinate, edge.destination.value.coordinate], count: 2)
                                switch edge.source.value.difficulty{
                                case .easy:
                                    poly.color = .Theme.easyColor
                                case .intermediate:
                                    poly.color = .Theme.intermediateColor
                                case .advanced:
                                    poly.color = .Theme.advancedColor
                                case .expertsOnly:
                                    poly.color = .Theme.expertsOnlyColor
                                case .lift:
                                    poly.color = .Theme.liftsColor
                                default:
                                    poly.color = .Theme.terrainParksColor
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

    func getMountainReport(webView: WKWebView, queryItems: TrailData, liftStatusId: String, trailStatusId: String, completion: @escaping (Result<TrailData, Error>) -> Void){
        var result = TrailData()
        webView.evaluateJavaScript("document.getElementById('\(liftStatusId)').innerHTML", completionHandler: { (value, error) in
            guard let html = value as? String, error == nil else{
                print("ERROR: \(error!)")
                completion(.failure(error!))
                return
            }
            print(queryItems.lifts)
            let liftStatuses = self.parseData(queryItems: queryItems.lifts.map({$0.lowercased()}), queryLocation: html.lowercased())
            result.lifts = liftStatuses
        })
        webView.evaluateJavaScript("document.getElementById('\(trailStatusId)').innerHTML", completionHandler: {
            (value, error) in
            guard let html = value as? String, error == nil else{
                print("ERROR: \(error!)")
                completion(.failure(error!))
                return
            }
            let trailStatuses = self.parseData(queryItems: queryItems.trails.map({$0.lowercased()}), queryLocation: html.lowercased())
            result.trails = trailStatuses
            completion(.success(result))
        })
    }

    func parseData(queryItems: [String], queryLocation: String) -> [String]
    {
        var result : [String] = []
        var string : String
        var substring: Substring
        for item in queryItems
        {
//            print("\(item), \(queryLocation.contains(item))")
            if let trail = queryLocation.index(of: item)
            {
                substring = queryLocation[..<trail]
                string = String(substring.reversed())
                if let getStatus1 = string.index(of: "\"=tla")
                {
                    substring = string[..<getStatus1]
                    string = String(substring.reversed())
                    if let getStatus2 = string.index(of: "\"")
                    {
                        substring = string[..<getStatus2]
                        string = String(substring)
                        result.append(string)
                        //print("Trail: \(item) Status: \(string)")
                    }
                    else {
                        result.append("closed")
                    }
                }
                else
                {
                    result.append("closed")
                }
            }
            else
            {
                result.append("closed")
            }
        }
        
        return result
    }
}
