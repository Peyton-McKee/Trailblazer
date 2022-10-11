//
//  TrailSelectorViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit

class TrailSelectorViewController : UIViewController{
    
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
    
    var searchController = UISearchController()
    var searchBarTableView = UITableView()
    var shouldShowSearchResults = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureTableViewAndSearchBar()
        createMyTrails()
    }
    
    private func configureTableViewAndSearchBar()
    {
        searchController = UISearchController(searchResultsController: nil)
        searchBarTableView.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height)
        searchBarTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        searchBarTableView.tableHeaderView = searchController.searchBar
        searchBarTableView.dataSource = self
        searchBarTableView.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        view.addSubview(searchBarTableView)
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
extension TrailSelectorViewController: UISearchBarDelegate, UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text{
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
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""
        {
            shouldShowSearchResults = false
        }
        else {
            shouldShowSearchResults = true
            if let cell = searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CustomCell{
                InteractiveMapViewController.destination = cell.cellTrail
            }
            searchBarTableView.reloadData()
        }
        
    }
    
    
}

extension TrailSelectorViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        9
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        if shouldShowSearchResults{
            cell.label.text = filteredTrails[indexPath.row].name
            cell.cellTrail = filteredTrails[indexPath.row]
        }
        else if (indexPath.section == 0)
        {
            cell.label.text = barkerTrails[indexPath.row].name
            cell.cellTrail = barkerTrails[indexPath.row]
        }
        else if (indexPath.section == 1)
        {
            cell.label.text = southridgeTrails[indexPath.row].name
            cell.cellTrail = southridgeTrails[indexPath.row]
        }
        else if (indexPath.section == 2)
        {
            cell.label.text = lockeTrails[indexPath.row].name
            cell.cellTrail = lockeTrails[indexPath.row]
        }
        else if (indexPath.section == 3)
        {
            cell.label.text = northPeakTrails[indexPath.row].name
            cell.cellTrail = northPeakTrails[indexPath.row]
        }
        else if (indexPath.section == 4)
        {
            cell.label.text = spruceTrails[indexPath.row].name
            cell.cellTrail = spruceTrails[indexPath.row]
        }
        else if (indexPath.section == 5)
        {
            cell.label.text = whiteCapTrails[indexPath.row].name
            cell.cellTrail = whiteCapTrails[indexPath.row]
        }
        else if (indexPath.section == 6)
        {
            cell.label.text = auroraTrails[indexPath.row].name
            cell.cellTrail = auroraTrails[indexPath.row]
        }
        else if (indexPath.section == 7)
        {
            cell.label.text = ozTrails[indexPath.row].name
            cell.cellTrail = ozTrails[indexPath.row]
        }
        else if (indexPath.section == 8)
        {
            cell.label.text = jordanTrails[indexPath.row].name
            cell.cellTrail = jordanTrails[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CustomCell{
            InteractiveMapViewController.destination = cell.cellTrail
        }
        
    }
}
