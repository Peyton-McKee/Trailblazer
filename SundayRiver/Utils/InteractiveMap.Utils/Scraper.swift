//
//  Scraper.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import Foundation
import WebKit

func getMountainReport(webView: WKWebView, queryItems: TrailData, completion: @escaping (Result<TrailData, Error>) -> Void){
    var result = TrailData()
    webView.evaluateJavaScript("document.getElementById('conditions_lifts_e75ceb523c30353d18fb54207af864f9').innerHTML", completionHandler: { (value, error) in
        guard let html = value as? String, error == nil else{
            print("ERROR: \(error!)")
            completion(.failure(error!))
            return
        }
        let liftStatuses = parseData(queryItems: queryItems.lifts!, queryLocation: html)
        result.lifts = liftStatuses
    })
    webView.evaluateJavaScript("document.getElementById('conditions_trailstatus_16207d4019cf36fbdb184831e2ae3054').innerHTML", completionHandler: {
        (value, error) in
        guard let html = value as? String, error == nil else{
            print("ERROR: \(error!)")
            completion(.failure(error!))
            return
        }
        let whiteCapTrails = parseData(queryItems: queryItems.whiteCapTrails!, queryLocation: html)
        result.whiteCapTrails = whiteCapTrails
        
        let lockeTrails = parseData(queryItems: queryItems.lockeTrails!, queryLocation: html)
        result.lockeTrails = lockeTrails
        
        let barkerTrails = parseData(queryItems: queryItems.barkerTrails!, queryLocation: html)
        result.barkerTrails = barkerTrails
        
        let southRidgeTrails = parseData(queryItems: queryItems.southRidgeTrails!, queryLocation: html)
        result.southRidgeTrails = southRidgeTrails
        
        let spruceTrails = parseData(queryItems: queryItems.spruceTrails!, queryLocation: html)
        result.spruceTrails = spruceTrails
        
        let northPeakTrails = parseData(queryItems: queryItems.northPeakTrails!, queryLocation: html)
        result.northPeakTrails = northPeakTrails
        
        let auroraTrails = parseData(queryItems: queryItems.auroraTrails!, queryLocation: html)
        result.auroraTrails = auroraTrails
        
        let ozTrails = parseData(queryItems: queryItems.ozTrails!, queryLocation: html)
        result.ozTrails = ozTrails
        
        let jordanTrails = parseData(queryItems: queryItems.jordantrails!, queryLocation: html)
        result.jordantrails = jordanTrails
        
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
        print("\(item), \(queryLocation.contains(item))")
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
                }
            }
        }
    }
    return result
}
//conditions_lifts_e75ceb523c30353d18fb54207af864f9 : Lift Status Id
//conditions_trailstatus_16207d4019cf36fbdb184831e2ae3054 : Trail Status Id

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
