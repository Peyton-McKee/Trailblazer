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
    var searchButton = UIButton()
    var imageView = UIImageView()
    var leftBackgroundView = UIView()
    var rightBackgroundView = UIView()
    var extendedFrame: CGRect?
    var initialFrame: CGRect?
    var isExtended = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setInitialFrame()
    {
        self.frame = initialFrame!
        self.leftBackgroundView.layer.cornerRadius = 10
    }
    func reloadView() {
        imageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        imageView.image = UIImage(systemName: "magnifyingglass")!
        searchButton.tintColor = .white
        
        searchButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
        searchButton.setImage(imageView.image, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        textField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 36, height: self.bounds.height)
        textField.placeholderRect(forBounds: textField.bounds)
        textField.placeholder = "Enter Destination"
        textField.backgroundColor = UIColor(hex: "#dddddd70")
        textField.layer.cornerRadius = 10
        
        leftBackgroundView.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 30, height: self.bounds.height)
        leftBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        rightBackgroundView.frame = CGRect(x: self.bounds.width - 20, y: 0, width: 20, height: self.bounds.height)
        rightBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        rightBackgroundView.layer.cornerRadius = 10
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        
        self.addSubview(textField)
        self.addSubview(rightBackgroundView)
        self.addSubview(leftBackgroundView)
        self.addSubview(searchButton)
    }
    
    func presentExtendedView(){
        self.isExtended = true
        self.leftBackgroundView.layer.cornerRadius = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.extendedFrame!
            self.reloadView()
        }, completion: nil)
    }
    func dismissExtendedView()
    {
        self.textField.endEditing(true)
        self.isExtended = false
        self.leftBackgroundView.layer.cornerRadius = 10
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.initialFrame!
            self.reloadView()
        }, completion: nil)
    }
    @objc func searchButtonPressed()
    {
        if !isExtended
        {
            self.presentExtendedView()
        }
        else
        {
            InteractiveMapViewController.wasCancelled = true
            self.dismissExtendedView()
        }
        
    }
}
class TrailSelectorView : UIView {
    
    static var searchText : String?
    
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
    
    var sections = ["Barker Mountain", "Southridge", "Locke Mountain", "North Peak", "Spruce Peak", "White Cap", "Aurora Peak", "Oz Mountain", "Jordan Bowl"]
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
//        searchBarHeaderView = SearchBarTableHeaderView(frame: CGRect(x: 0, y: 0, width: self.layoutMarginsGuide.widthAnchor.accessibilityFrame.width, height: self.bounds.height/20 ))
//        searchBarHeaderView!.configure()
//        searchBarTableView.tableHeaderView = searchBarHeaderView
//        searchBar = searchBarHeaderView?.textField
//        searchBar!.delegate = self
        searchBarTableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 8.5 / 10)
        searchBarTableView.layer.cornerRadius = 15
        searchBarTableView.register(TrailSelectorCustomCell.self, forCellReuseIdentifier: "TrailSelectorCustomCell")
        searchBarTableView.backgroundColor = .black
        searchBarTableView.dataSource = self
        searchBarTableView.delegate = self

        //        searchBar.frame = CGRect(x: 10, y: 10, width: searchBarTableView.layoutMarginsGuide.widthAnchor.accessibilityFrame.width, height: self.bounds.height / 20)
        self.addSubview(searchBarTableView)
        NotificationCenter.default.addObserver(self, selector: #selector(filterTrails), name: Notification.Name(rawValue: "searchTrail"), object: nil)
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
    @objc func filterTrails()
    {
        print("test")
        if let searchString = TrailSelectorView.searchText{
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
        else
        {
            return sections[section]
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
            cell.label.textColor = UIColor(red: 0.03, green: 0.25, blue: 0, alpha: 1)
        case .intermediate:
            cell.label.textColor = .blue
        case .advanced:
            cell.label.textColor = .black
        case .expertsOnly:
            cell.label.textColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        default:
            cell.label.textColor = .orange
        }
        cell.label.font = UIFont(name: "markerfelt-wide", size: 15)
        cell.backgroundColor =  .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrailSelectorCustomCell{
            
            InteractiveMapViewController.destination = cell.cellTrail!.annotations[0]
            InteractiveMapViewController.routeInProgress = false
            InteractiveMapViewController.container.add()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .darkGray
            headerView.textLabel?.textColor = .purple
        }
    }
    
}


