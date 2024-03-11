//
//  TrailSelectorViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit
enum TextFieldType {
    case origin
    case destination
}

final class TrailSelectorView : UIView {
    var isPresented = false
    var currentTextField: UITextField?
    var currentTextFieldType: TextFieldType = .destination
    var easyTrails : [ImageAnnotation] = []
    var intermediateTrails : [ImageAnnotation] = []
    var advancedTrails : [ImageAnnotation] = []
    var expertsOnlyTrails : [ImageAnnotation] = []
    var terrainParks : [ImageAnnotation] = []
    var lifts: [ImageAnnotation] = []
    var filteredTrails : [ImageAnnotation] = []
    var totalTrails: [ImageAnnotation] = []
    
    var sections = ["Easy", "Intermediate", "Advanced", "Experts Only", "Terrain Parks", "Lifts"]
    
    var searchBar : UITextField?
    var searchBarHeaderView : SearchBarTableHeaderView?
    var searchBarTableView = UITableView()
    var shouldShowSearchResults = false
    var selectedOrigin : ImageAnnotation? = nil
    
    let vertices : [Vertex<ImageAnnotation>]
    
    let selectedTrail: (_ origin: ImageAnnotation?, _ destination: ImageAnnotation) -> Void
    
    init(frame: CGRect, vertices: [Vertex<ImageAnnotation>], selectedTrail: @escaping (_ origin: ImageAnnotation?, _ destination: ImageAnnotation) -> Void) {
        self.vertices = vertices
        self.selectedTrail = selectedTrail
        super.init(frame: frame)
        self.configureSearchBarTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMyTrails), name: Notification.Name.Names.configureTrailSelector, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filterTrails), name: Notification.Name.Names.filterTrails, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSearchBarTableView()
    {
        self.createMyTrails()
        self.searchBarTableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 8 / 10)
        self.searchBarTableView.layer.cornerRadius = 15
        self.searchBarTableView.register(TrailSelectorTableViewCell.self, forCellReuseIdentifier: "TrailSelectorCustomCell")
        self.searchBarTableView.backgroundColor = .black
        self.searchBarTableView.dataSource = self
        self.searchBarTableView.delegate = self
        self.addSubview(self.searchBarTableView)
    }
    
    @objc func reloadMyTrails()
    {
        self.easyTrails = []
        self.intermediateTrails = []
        self.advancedTrails = []
        self.expertsOnlyTrails = []
        self.terrainParks = []
        self.lifts = []
        self.filteredTrails = []
        self.totalTrails = []
        self.createMyTrails()
        self.searchBarTableView.reloadData()
    }
    
    private func createMyTrails()
    {
        var foundTrails : [String] = []
        for annotation in self.vertices.map({ $0.value })
        {
            if(!foundTrails.contains(annotation.title!))
            {
                foundTrails.append(annotation.title!)
                totalTrails.append(annotation)
                switch annotation.difficulty
                {
                case .easy:
                    easyTrails.append(annotation)
                case .intermediate:
                    intermediateTrails.append(annotation)
                case .advanced:
                    advancedTrails.append(annotation)
                case .expertsOnly:
                    expertsOnlyTrails.append(annotation)
                case .terrainPark:
                    terrainParks.append(annotation)
                default:
                    lifts.append(annotation)
                }
            }
        }
    }
    
    @objc func filterTrails(sender: NSNotification)
    {
        if let searchString = sender.userInfo?["searchText"] as? String {
            for trail in totalTrails
            {
                if trail.title!.lowercased().contains(searchString.lowercased()) && !filteredTrails.contains(where: {$0.title!.lowercased() == trail.title!.lowercased()})
                {
                    filteredTrails.append(trail)
                }
                if searchString == ""
                {
                    filteredTrails = []
                    shouldShowSearchResults = false
                    searchBarTableView.reloadData()
                }
                if filteredTrails.contains(where: {!$0.title!.lowercased().contains(searchString.lowercased())})
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
extension TrailSelectorView: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(shouldShowSearchResults)
        {
            return 1
        }
        else
        {
            return sections.count
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
        switch section
        {
        case 0:
            return easyTrails.count
        case 1:
            return intermediateTrails.count
        case 2:
            return advancedTrails.count
        case 3:
            return expertsOnlyTrails.count
        case 4:
            return terrainParks.count
        case 5:
            return lifts.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrailSelectorCustomCell", for: indexPath) as! TrailSelectorTableViewCell
        if shouldShowSearchResults{
            cell.label.text = filteredTrails[indexPath.row].title
            cell.cellTrail = filteredTrails[indexPath.row]
        }
        else
        {
            switch indexPath.section
            {
            case 0:
                cell.label.text = easyTrails[indexPath.row].title
                cell.cellTrail = easyTrails[indexPath.row]
            case 1:
                cell.label.text = intermediateTrails[indexPath.row].title
                cell.cellTrail = intermediateTrails[indexPath.row]
            case 2:
                cell.label.text = advancedTrails[indexPath.row].title
                cell.cellTrail = advancedTrails[indexPath.row]
            case 3:
                cell.label.text = expertsOnlyTrails[indexPath.row].title
                cell.cellTrail = expertsOnlyTrails[indexPath.row]
            case 4:
                cell.label.text = terrainParks[indexPath.row].title
                cell.cellTrail = terrainParks[indexPath.row]
            case 5:
                cell.label.text = lifts[indexPath.row].title
                cell.cellTrail = lifts[indexPath.row]
            default:
                break
            }
        }
        switch cell.cellTrail?.difficulty{
        case .easy:
            cell.label.textColor = UIColor(red: 0.03, green: 0.25, blue: 0, alpha: 1)
        case .intermediate:
            cell.label.textColor = .blue
        case .advanced:
            cell.label.textColor = .darkGray
        case .expertsOnly:
            cell.label.textColor = .black
        case .terrainPark:
            cell.label.textColor = .orange
        default:
            cell.label.textColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        }
        cell.label.font = .Theme.markerFelt
        cell.backgroundColor = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrailSelectorTableViewCell{
            switch currentTextFieldType
            {
            case .destination:
                self.selectedTrail(self.selectedOrigin, cell.cellTrail!)
                self.isPresented = false
            case .origin:
                currentTextField?.text = cell.cellTrail?.title
                self.selectedOrigin = cell.cellTrail!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .darkGray
            headerView.textLabel?.textColor = .purple
        }
    }
    
}


