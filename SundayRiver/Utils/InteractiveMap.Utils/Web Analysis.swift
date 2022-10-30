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
struct TrailData{
    var lifts: [String]?
    var whiteCapTrails: [String]?
    var lockeTrails : [String]?
    var barkerTrails: [String]?
    var southRidgeTrails : [String]?
    var spruceTrails : [String]?
    var northPeakTrails : [String]?
    var auroraTrails : [String]?
    var ozTrails: [String]?
    var jordantrails: [String]?
}
class WebAnalysis: NSObject, WKNavigationDelegate {
    
    let webView = WKWebView(frame: .zero)
    let liftNames = ["Barker Mountain Express #1", "South Ridge Express #2", "Quantum Leap Triple #3", "Locke Mountain Triple #4", /*"Alera Group Competition Lift #5",*/ "North Peak Express #6", "Chondola #7", "Spruce Peak Triple #8", "White Cap Quad #9", "White Heat Quad #10", "Little White Cap Quad #11", "Aurora Peak Quad #12", "Jordan Mountain Double #13", "Jordan Bowl Express #14", /*"OZ Quad #15"*/]
    let whiteCapTrailNames = ["Salvation", "Heat's Off", "Obsession", "Chutzpah", "White Heat", "Shock Wave", "Upper Tempest", "Jibe", "Heat's On", "Green Cheese", "Upper Moonstruck", "Assumption", "Starlight", "Starstruck", "Starwood", "Starburst", "Bear Paw", "Wildfire", "Cutoff", "Snowbound"]
    let lockeTrailNames = ["Goat Path", "Upper Cut", "Upper Sunday Punch", "Locke Line", "Jim's Whim", "T2", "Bim's Whim", "Cascades", "Road Runner", "Lower Upper Cut", "Sunday Punch", "Tightwire"]
    let barkerTrailNames = ["Three Mile Trail", "Lazy River", "Sluice", "Right Stuff", "Agony", "Top Gun", "Ecstasy", "Jungle Road", "South Paw", "Rocking Chair", "Tourist Trap"]
    let southRidgeNames = ["Ridge Run", "Broadway", "Lower Lazy River", "Thataway", "Mixing Bowl", "Lower Chondi Line", "Who-Ville", "Wonderland Park", "Northway", "Spectator", "Double Dipper", "Sundance"]
    let spruceNames = ["Sirius", "Upper Downdraft", "American Express", "Upper Risky Business", "Gnarnia", "Lower Downdraft"]
    let northPeakNames = ["Paradigm", "Second Mile", "Grand Rapids", "Dream Maker", "T72", "Sensation", "Dream Maker", "Escapade", "3D", "Second Thoughts"]
    let auroraNames = ["Cyclone", "Northern Lights", "Witch Way", "Airglow", "Black Hole", "Firestar", "Lights Out", "Borealis", "Vortex", "Quantum leap"]
    let ozNames = ["Tin Woodsman", "Kansas"]
    
    let jordanNames = ["Lollapalooza", "Excalibur", "Rogue Angel", "Caramba"]
    
    let urlRequest = URLRequest(url: URL(string: "https://www.sundayriver.com/mountain-report")!)
    func makeRequest()
    {
        webView.navigationDelegate = self
        webView.load(urlRequest)
    }
    
    func assignStatus(item: [String], assignLift: [Lift]?, assignTrail: [Trail]?)
    {
        var status : Status
        for i in 0...item.count-1
        {
            if (item[i] == "Closed")
            {
                status = .closed
            }
            else if(item[i] == "Open")
            {
                status = .open
            }
            else if(item[i] == "On Hold")
            {
                status = .onHold
            }
            else if(item[i] == "Scheduled")
            {
                status = .scheduled
            }
            else
            {
                status = .event
            }
            if let lifts = assignLift
            {
                lifts[i].annotations[0].status = status
                continue
            }
            if let trails = assignTrail
            {
                trails[i].annotations[0].status = status
                continue
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("test")
        getMountainReport(webView: webView, queryItems: TrailData(lifts: liftNames, whiteCapTrails: whiteCapTrailNames, lockeTrails: lockeTrailNames, barkerTrails: barkerTrailNames, southRidgeTrails: southRidgeNames, spruceTrails: spruceNames, northPeakTrails: northPeakNames, auroraTrails: auroraNames, ozTrails: ozNames, jordantrails: jordanNames), completion: {
            value in
            switch value{
            case .success(let value):
                self.assignStatus(item: value.lifts!, assignLift: TrailsDatabase.Lifts, assignTrail: nil)
                self.assignStatus(item: value.whiteCapTrails!, assignLift: nil, assignTrail: TrailsDatabase.whiteCapTrails)
                self.assignStatus(item: value.lockeTrails!, assignLift: nil, assignTrail: TrailsDatabase.lockeTrails)
                self.assignStatus(item: value.barkerTrails!, assignLift: nil, assignTrail: TrailsDatabase.barkerTrails)
                self.assignStatus(item: value.southRidgeTrails!, assignLift: nil, assignTrail: TrailsDatabase.southRidgeTrails)
                self.assignStatus(item: value.spruceTrails!, assignLift: nil, assignTrail: TrailsDatabase.southRidgeTrails)
                self.assignStatus(item: value.northPeakTrails!, assignLift: nil, assignTrail: TrailsDatabase.NorthPeakTrails)
                self.assignStatus(item: value.auroraTrails!, assignLift: nil, assignTrail: TrailsDatabase.AuroraTrails)
                self.assignStatus(item: value.ozTrails!, assignLift: nil, assignTrail: TrailsDatabase.OzTrails)
                self.assignStatus(item: value.jordantrails!, assignLift: nil, assignTrail: TrailsDatabase.jordanTrails)
            case .failure(let error):
                    print("failed to find data - \(error)")
            }
        })
    }

}

