//
//  Scraper.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import Foundation
import WebKit

func getWebsiteData(webView: WKWebView, completion: @escaping (Result<[String], Error>) -> Void){
    webView.evaluateJavaScript("document.body.innerHTML", completionHandler: { (value, error) in
        //            webView.evaluateJavaScript("document.getElementById('Email').value = '\(emailTF.text!)'", completionHandler: {(value, error) in
        guard let html = value as? String, error == nil else{
            print("ERROR: \(error!)")
            completion(.failure(error!))
            return
        }
        let liftStatusHTML = html.components(separatedBy: "Lift Status")[1]
        var liftStatuses = [String]()
        liftStatuses.append(parseCode(html: liftStatusHTML, number: "Barker Mountain Express"))
        for i in 2 ..< 16
        {
            liftStatuses.append(parseCode(html: liftStatusHTML, number: "#\(i)"))
        }
//        let barkerStatus = parseCode(html: liftStatus, number: "#1")
//        let southRidgeStatus = parseCode(html: liftStatus, number: "#2")
//        let quatumLeapStatus = parseCode(html: liftStatus, number: "#3")
//        let lockeStatus = parseCode(html: liftStatus, number: "#4")
//        let aleraCompStatus = parseCode(html: liftStatus, number: "#5")
//        let northPeakStatus = parseCode(html: liftStatus, number: "#6")
//        let chondolaStatus = parseCode(html: liftStatus, number: "#7")
//        let spruceStatus = parseCode(html: liftStatus, number: "#8")
//        let whiteCapQuadStatus = parseCode(html: liftStatus, number: "#9")
//        let whiteHeatStatus = parseCode(html: liftStatus, number: "#10")
//        let littleWhiteCapStatus = parseCode(html: liftStatus, number: "#11")
//        let auroraStatus = parseCode(html: liftStatus, number: "#12")
//        let jordanDoubleStatus = parseCode(html: liftStatus, number: "#13")
//        let jordanStatus = parseCode(html: liftStatus, number: "#14")
//        let ozStatus = parseCode(html: liftStatus, number: "#15")
//

        completion(.success(liftStatuses))
    })
}

func parseCode(html : String, number : String) -> String
{
    return String(String(html.components(separatedBy: number)[0].reversed()).components(separatedBy: "\"=tla")[0].reversed()).components(separatedBy: "\"")[0]
    
}
