//
//  Scraper.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import Foundation
import WebKit

func getMountainReport(webView: WKWebView, queryItems: TrailData, liftStatusId: String, trailStatusId: String, completion: @escaping (Result<TrailData, Error>) -> Void){
    var result = TrailData()
    webView.evaluateJavaScript("document.getElementById('\(liftStatusId)').innerHTML", completionHandler: { (value, error) in
        guard let html = value as? String, error == nil else{
            print("ERROR: \(error!)")
            completion(.failure(error!))
            return
        }
        print(queryItems.lifts)
        let liftStatuses = parseData(queryItems: queryItems.lifts.map({$0.lowercased()}), queryLocation: html.lowercased())
        result.lifts = liftStatuses
    })
    webView.evaluateJavaScript("document.getElementById('\(trailStatusId)').innerHTML", completionHandler: {
        (value, error) in
        guard let html = value as? String, error == nil else{
            print("ERROR: \(error!)")
            completion(.failure(error!))
            return
        }
        let trailStatuses = parseData(queryItems: queryItems.trails.map({$0.lowercased()}), queryLocation: html.lowercased())
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
        //print("\(item), \(queryLocation.contains(item))")
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

//conditions_lifts_e75ceb523c30353d18fb54207af864f9 : Lift Status Id Sunday River
//conditions_trailstatus_16207d4019cf36fbdb184831e2ae3054 : Trail Status Id Sunday River
//conditions_lifts_dee2e4a816064ad8b3df04324de73500 : Lift Status Id Sugarloaf
//conditions_trailstatus_fd4ed0a91d27736243553866f5ab6f8e : Trail Status Id Sugarloaf

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
