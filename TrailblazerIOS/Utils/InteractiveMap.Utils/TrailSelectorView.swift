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

final class SearchBarTableHeaderView: UIView {
    var destinationTextField = UITextField()
    var searchButton = UIButton()
    var directionsButton = UIButton()
    var searchImageView = UIImageView()
    var directionsImageView = UIImageView()
    var leftBackgroundView = UIView()
    var rightBackgroundView = UIView()
    var extendedFrame: CGRect?
    var initialFrame: CGRect?
    var droppedDownFrame : CGRect?
    var isExtended = false
    var isDroppedDown = false
    var originTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setInitialFrame()
    {
        self.frame = initialFrame!
        leftBackgroundView.layer.cornerRadius = 10
        directionsButton.isHidden = true
        
        searchImageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        searchImageView.image = UIImage(systemName: "magnifyingglass")!
        
        directionsImageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        directionsImageView.image = UIImage(systemName: "eye.circle")!
        searchButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
        searchButton.tintColor = .white
        searchButton.setImage(searchImageView.image, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
        directionsButton.tintColor = .white
        directionsButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
        directionsButton.setImage(directionsImageView.image, for: .normal)
        directionsButton.addTarget(self, action: #selector(directionsButtonPressed), for: .touchUpInside)
        
        destinationTextField.placeholderRect(forBounds: destinationTextField.bounds)
        destinationTextField.placeholder = "Enter Destination"
        destinationTextField.backgroundColor = UIColor(hex: "#dddddd70")
        destinationTextField.layer.cornerRadius = 10
        
        originTextField.placeholderRect(forBounds: originTextField.bounds)
        originTextField.placeholder = "Origin: Your Location..."
        originTextField.backgroundColor = UIColor(hex: "#dddddd70")
        originTextField.layer.cornerRadius = 10
        originTextField.isHidden = true
        
        leftBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        rightBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        rightBackgroundView.layer.cornerRadius = 10
        
        leftBackgroundView.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 30, height: self.bounds.height)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        
    
        self.addSubview(destinationTextField)
        self.addSubview(originTextField)
        self.addSubview(rightBackgroundView)
        self.addSubview(leftBackgroundView)
        self.addSubview(searchButton)
        self.addSubview(directionsButton)
    }
    func reloadView() {
        
        originTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height/2)

        rightBackgroundView.frame = CGRect(x: self.bounds.width - 20, y: 0, width: 20, height: self.bounds.height)
    }
    
    func presentExtendedView(){
        self.isExtended = true
        self.leftBackgroundView.layer.cornerRadius = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.extendedFrame!
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-80, y: 0, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 80, y: 0, width: 70, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height)
            self.directionsButton.isHidden = false
        }, completion: nil)
    }
    func dismissExtendedView()
    {
        self.destinationTextField.endEditing(true)
        self.originTextField.endEditing(true)
        self.isExtended = false
        self.leftBackgroundView.layer.cornerRadius = 10
        self.directionsButton.isHidden = true
        self.isDroppedDown = false
        self.originTextField.isHidden = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.initialFrame!
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 30, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height)
        }, completion: nil)
    }
    
    func presentDropDownView()
    {
        self.originTextField.isHidden = false
        self.isDroppedDown = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.droppedDownFrame!
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-80, y: self.bounds.height/4, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width - 40, y: self.bounds.height/4, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 80, y: 0, width: 70, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width - 40, height: self.bounds.height/2)
        }, completion: nil)
    }
    func dismissDropDownView()
    {
        self.originTextField.endEditing(true)
        self.originTextField.isHidden = true
        self.isDroppedDown = false
        InteractiveMapViewController.origin = nil
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.extendedFrame!
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-80, y: 0, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 80, y: 0, width: 70, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height)

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
    @objc func directionsButtonPressed()
    {
        if !isDroppedDown
        {
            presentDropDownView()
        }
        else
        {
            dismissDropDownView()
        }
    }
}
final class TrailSelectorView : UIView {
    static var searchText : String?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureTableViewAndSearchBar()
    {
        createMyTrails()
        searchBarTableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 8.5 / 10)
        searchBarTableView.layer.cornerRadius = 15
        searchBarTableView.register(TrailSelectorTableViewCell.self, forCellReuseIdentifier: "TrailSelectorCustomCell")
        searchBarTableView.backgroundColor = .black
        searchBarTableView.dataSource = self
        searchBarTableView.delegate = self
        
        //        searchBar.frame = CGRect(x: 10, y: 10, width: searchBarTableView.layoutMarginsGuide.widthAnchor.accessibilityFrame.width, height: self.bounds.height / 20)
        self.addSubview(searchBarTableView)
    }
    func reloadMyTrails()
    {
        easyTrails = []
        intermediateTrails = []
        advancedTrails = []
        expertsOnlyTrails = []
        terrainParks = []
        lifts = []
        filteredTrails = []
        totalTrails = []
        createMyTrails()
        searchBarTableView.reloadData()
    }
    private func createMyTrails()
    {
        var foundTrails : [String] = []
        for annotation in InteractiveMapViewController.selectedGraph.vertices.map({ $0.value })
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
    @objc func filterTrails()
    {
        print("test")
        if let searchString = TrailSelectorView.searchText{
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
        cell.label.font = UIFont(name: "markerfelt-wide", size: 15)
        cell.backgroundColor = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrailSelectorTableViewCell{
            switch currentTextFieldType
            {
            case .destination:
                InteractiveMapViewController.destination = cell.cellTrail!
                InteractiveMapViewController.routeInProgress = false
                InteractiveMapViewController.didChooseDestination = true
                NotificationCenter.default.post(name: Notification.Name("selectedTrail"), object: nil)
                self.isPresented = false
            case .origin:
                currentTextField?.text = cell.cellTrail?.title
                InteractiveMapViewController.origin = cell.cellTrail!
                InteractiveMapViewController.wasSelectedWithOrigin = true
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


