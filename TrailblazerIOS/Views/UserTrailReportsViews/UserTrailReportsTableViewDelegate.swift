//
//  UserTrailReportsTableViewDelegate.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

extension UserTrailReportsView: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailReportTableViewCell", for: indexPath) as! TrailReportTableViewCell
        cell.layer.cornerRadius = 15
        cell.backgroundColor = .darkGray
        cell.cellTrailReport = trailReports[indexPath.row]
        cell.backView.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        cell.configure()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! TrailReportTableViewCell
//
//    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
