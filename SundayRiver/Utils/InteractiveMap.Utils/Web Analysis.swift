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

class WebAnalysis: NSObject, WKNavigationDelegate {
    
    let webView = WKWebView(frame: .zero)
    let liftNames = ["Barker Mountain Express #1", "South Ridge Express #2", "Quantum Leap Triple #3", "Locke Mountain Triple #4", /*"Alera Group Competition Lift #5",*/ "North Peak Express #6", "Chondola #7", "Spruce Peak Triple #8", "White Cap Quad #9", "White Heat Quad #10", "Little White Cap Quad #11", "Aurora Peak Quad #12", "Jordan Mountain Double #13", "Jordan Bowl Express #14", /*"OZ Quad #15"*/]
    var closedLifts = ""
    
    let urlRequest = URLRequest(url: URL(string: "https://www.sundayriver.com/mountain-report")!)
    func makeRequest()
    {
        webView.navigationDelegate = self
        webView.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("test")
        getMountainReport(webView: webView, liftQueryItems: liftNames, completion: {
            value in
            switch value{
            case .success(let value):
                var status : Status
                for i in 0...value.count-1
                {
                    if (value[i] == "Closed")
                    {
                        status = .closed
                    }
                    else if(value[i] == "Open")
                    {
                        status = .open
                    }
                    else if(value[i] == "On Hold")
                    {
                        status = .onHold
                    }
                    else if(value[i] == "Scheduled")
                    {
                        status = .scheduled
                    }
                    else
                    {
                        status = .event
                    }
                    TrailsDatabase.Lifts[i].annotations[0].status = status
                }
            case .failure(let error):
                    print("failed to find data - \(error)")
            }
        })
    }
}

