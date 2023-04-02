//
//  TableViewDelegate.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrailReportTypeTableViewCell", for: indexPath) as? TrailReportTypeTableViewCell else {fatalError("Unable to deque cell")}
        cell.lbl.text = settingArray[indexPath.row]
        if(settingArray[indexPath.row] == TrailReportType.moguls.rawValue)
        {
            cell.settingImage.image = UIImage(named: "MogulSquare.png")!
        }
        else if (settingArray[indexPath.row] == TrailReportType.ice.rawValue)
        {
            cell.settingImage.image = UIImage(named: "IcySquare.png")!
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select A Trail Report"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TrailReportTypeTableViewCell
        switch cell.lbl.text{
        case TrailReportType.moguls.rawValue:
            createTrailReport(type: .moguls)
        case TrailReportType.ice.rawValue:
            createTrailReport(type: .ice)
        case TrailReportType.crowded.rawValue:
            createTrailReport(type: .crowded)
        case TrailReportType.thinCover.rawValue:
            createTrailReport(type: .thinCover)
        case TrailReportType.longLiftLine.rawValue:
            createTrailReport(type: .longLiftLine)
        case TrailReportType.snowmaking.rawValue:
            createTrailReport(type: .snowmaking)
        default:
            dismissTrailReportMenu()
        }
    }
}
