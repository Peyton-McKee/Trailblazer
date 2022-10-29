//
//  Scraper.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import Foundation
import WebKit

func getMountainReport(webView: WKWebView, liftQueryItems: [String], completion: @escaping (Result<[String], Error>) -> Void){
    webView.evaluateJavaScript("document.getElementById('conditions_lifts_e75ceb523c30353d18fb54207af864f9').innerHTML", completionHandler: { (value, error) in
        guard let html = value as? String, error == nil else{
            print("ERROR: \(error!)")
            completion(.failure(error!))
            return
        }
        var statuses : [String] = []
        var string : String
        var substring: Substring
        for item in liftQueryItems
        {
            if let trail = html.index(of: item)
            {
                substring = html[..<trail]
                string = String(substring.reversed())
                if let getStatus1 = string.index(of: "\"=tla")
                {
                    substring = string[..<getStatus1]
                    string = String(substring.reversed())
                    if let getStatus2 = string.index(of: "\"")
                    {
                        substring = string[..<getStatus2]
                        string = String(substring)
                        statuses.append(string)
                    }
                }
            }
            
        }
        completion(.success(statuses))
    })
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
