//
//  TrailSelectorViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit

class SearchBarTableHeaderView: UIView {
    var textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure() {
        textField.frame = CGRect(x: 10, y: 10, width: 180, height: self.bounds.height)
        textField.placeholderRect(forBounds: textField.bounds)
        
        textField.placeholder = "Enter Destination"
        textField.backgroundColor = UIColor(hex: "#800000ff")
        textField.layer.cornerRadius = 10
        
        self.addSubview(textField)
    }
}
class TrailSelectorView : UIView {
    
    var barkerTrails : [Trail] = []
    var southridgeTrails : [Trail] = []
    var lockeTrails : [Trail] = []
    var northPeakTrails : [Trail] = []
    var whiteCapTrails : [Trail] = []
    var spruceTrails : [Trail] = []
    var auroraTrails : [Trail] = []
    var ozTrails : [Trail] = []
    var jordanTrails : [Trail] = []
    var filteredTrails : [Trail] = []
    var totalTrails : [Trail]  = []
    
    var searchBar : UITextField?
    var searchBarHeaderView : SearchBarTableHeaderView?
    var searchBarTableView = UITableView()
    var shouldShowSearchResults = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureTableViewAndSearchBar()
    {
        createMyTrails()
        searchBarHeaderView = SearchBarTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.layoutMarginsGuide.widthAnchor.accessibilityFrame.width, height: self.bounds.height/20 ))
        searchBarHeaderView!.configure()
        searchBarTableView.frame = CGRect(x: 0, y: 50, width: self.bounds.width, height: self.bounds.height * 8.5 / 10)
        searchBarTableView.layer.cornerRadius = 15
        searchBarTableView.register(TrailSelectorCustomCell.self, forCellReuseIdentifier: "TrailSelectorCustomCell")
        searchBarTableView.tableHeaderView = searchBarHeaderView
        searchBarTableView.backgroundColor = .black
        searchBarTableView.dataSource = self
        searchBarTableView.delegate = self
        searchBar = searchBarHeaderView?.textField
        searchBar!.delegate = self
        //        searchBar.frame = CGRect(x: 10, y: 10, width: searchBarTableView.layoutMarginsGuide.widthAnchor.accessibilityFrame.width, height: self.bounds.height / 20)
        self.addSubview(searchBarTableView)
    }
    private func createMyTrails()
    {
        for trail in TrailsDatabase.barkerTrails
        {
            barkerTrails.append(trail)
        }
        for trail in TrailsDatabase.southRidgeTrails
        {
            southridgeTrails.append(trail)
        }
        for trail in TrailsDatabase.NorthPeakTrails
        {
            northPeakTrails.append(trail)
        }
        for trail in TrailsDatabase.lockeTrails
        {
            lockeTrails.append(trail)
        }
        for trail in TrailsDatabase.whiteCapTrails
        {
            whiteCapTrails.append(trail)
        }
        for trail in TrailsDatabase.spruceTrails
        {
            spruceTrails.append(trail)
        }
        for trail in TrailsDatabase.AuroraTrails
        {
            auroraTrails.append(trail)
        }
        for trail in TrailsDatabase.OzTrails
        {
            ozTrails.append(trail)
        }
        for trail in TrailsDatabase.jordanTrails
        {
            jordanTrails.append(trail)
        }
        totalTrails.append(contentsOf: barkerTrails)
        totalTrails.append(contentsOf: southridgeTrails)
        totalTrails.append(contentsOf: northPeakTrails)
        totalTrails.append(contentsOf: lockeTrails)
        totalTrails.append(contentsOf: whiteCapTrails)
        totalTrails.append(contentsOf: auroraTrails)
        totalTrails.append(contentsOf: ozTrails)
        totalTrails.append(contentsOf: jordanTrails)
    }
}
extension TrailSelectorView: UITextFieldDelegate
{
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if let searchString = textField.text{
            for trail in totalTrails
            {
                if trail.name.lowercased().contains(searchString.lowercased()) && !filteredTrails.contains(where: {$0.name.lowercased() == trail.name.lowercased()})
                {
                    filteredTrails.append(trail)
                }
                if searchString == ""
                {
                    filteredTrails = []
                    shouldShowSearchResults = false
                    searchBarTableView.reloadData()
                }
                if filteredTrails.contains(where: {!$0.name.lowercased().contains(searchString.lowercased())})
                {
                    filteredTrails.remove(at: 0)
                }
            }
            if searchString == ""
            {
                shouldShowSearchResults = false
                searchBarTableView.reloadData()
            }
            else
            {
                shouldShowSearchResults = true
                searchBarTableView.reloadData()
            }
        }
        return true
    }
    
}

extension TrailSelectorView: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(shouldShowSearchResults)
        {
            return 1
        }
        else
        {
            return 9
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(shouldShowSearchResults)
        {
            return "Results"
        }
        else if(section == 0)
        {
            return "Barker Mountain"
        }
        else if (section == 1)
        {
            return "South Ridge"
        }
        else if (section == 2)
        {
            return "Locke Mountain"
        }
        else if (section == 3)
        {
            return "North Peak"
        }
        else if (section == 4)
        {
            return "Spruce Peak"
        }
        else if (section == 5)
        {
            return "White Cap"
        }
        else if (section == 6)
        {
            return "Aurora Peak"
        }
        else if (section == 7)
        {
            return "Oz Mountain"
        }
        else
        {
            return "Jordan Bowl"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return filteredTrails.count
        }
        else if (section == 8)
        {
            return jordanTrails.count
        }
        else if (section == 0)
        {
            return barkerTrails.count
        }
        else if (section == 1)
        {
            return southridgeTrails.count
        }
        else if (section == 2)
        {
            return lockeTrails.count
        }
        else if (section == 3)
        {
            return northPeakTrails.count
        }
        else if (section == 4)
        {
            return spruceTrails.count
        }
        else if (section == 5)
        {
            return whiteCapTrails.count
        }
        else if (section == 6)
        {
            return auroraTrails.count
        }
        else
        {
            return ozTrails.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailSelectorCustomCell", for: indexPath) as! TrailSelectorCustomCell
        if shouldShowSearchResults{
            cell.label.text = filteredTrails[indexPath.row].name
            cell.cellTrail = filteredTrails[indexPath.row]
        }
        else
        {
            switch indexPath.section
            {
            case 0:
                cell.label.text = barkerTrails[indexPath.row].name
                cell.cellTrail = barkerTrails[indexPath.row]
            case 1:
                cell.label.text = southridgeTrails[indexPath.row].name
                cell.cellTrail = southridgeTrails[indexPath.row]
            case 2:
                cell.label.text = lockeTrails[indexPath.row].name
                cell.cellTrail = lockeTrails[indexPath.row]
            case 3:
                cell.label.text = northPeakTrails[indexPath.row].name
                cell.cellTrail = northPeakTrails[indexPath.row]
            case 4:
                cell.label.text = spruceTrails[indexPath.row].name
                cell.cellTrail = spruceTrails[indexPath.row]
            case 5:
                cell.label.text = whiteCapTrails[indexPath.row].name
                cell.cellTrail = whiteCapTrails[indexPath.row]
            case 6:
                cell.label.text = auroraTrails[indexPath.row].name
                cell.cellTrail = auroraTrails[indexPath.row]
            case 7:
                cell.label.text = ozTrails[indexPath.row].name
                cell.cellTrail = ozTrails[indexPath.row]
            default:
                cell.label.text = jordanTrails[indexPath.row].name
                cell.cellTrail = jordanTrails[indexPath.row]
            }
        }
        switch cell.cellTrail?.difficulty{
        case .easy:
            cell.label.textColor = .green
        case .intermediate:
            cell.label.textColor = .blue
        case .advanced:
            cell.label.textColor = .black
        case .expertsOnly:
            cell.label.textColor = .red
        default:
            cell.label.textColor = .orange
        }
        cell.label.font = UIFont(name: "Times New Roman", size: 15)
        cell.backgroundColor = UIColor(hex: "#6488eaff")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrailSelectorCustomCell{
            InteractiveMapViewController.destination = cell.cellTrail!.annotations[0]
            InteractiveMapViewController.routeInProgress = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: "selectedTrail"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .darkGray
            headerView.textLabel?.textColor = .purple
        }
    }
}


