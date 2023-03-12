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
    let destinationTextField : UITextField = {
        let destinationTextField = UITextField()
        destinationTextField.placeholderRect(forBounds: destinationTextField.bounds)
        destinationTextField.placeholder = "Enter Destination"
        destinationTextField.backgroundColor = UIColor(hex: "#dddddd70")
        destinationTextField.layer.cornerRadius = 10
        return destinationTextField
    }()
    
    let originTextField : UITextField = {
        let originTextField = UITextField()
        originTextField.placeholderRect(forBounds: originTextField.bounds)
        originTextField.placeholder = "Origin: Your Location..."
        originTextField.backgroundColor = UIColor(hex: "#dddddd70")
        originTextField.layer.cornerRadius = 10
        originTextField.isHidden = true
        return originTextField
    }()
    
    lazy var searchButton : UIButton = {
        let searchButton = UIButton(frame: CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40))
        searchButton.tintColor = .white
        searchButton.setImage(searchImageView.image, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return searchButton
    }()
    
    lazy var directionsButton : UIButton = {
        let directionsButton = UIButton(frame: CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40))
        directionsButton.isHidden = true
        directionsButton.tintColor = .white
        directionsButton.setImage(directionsImageView.image, for: .normal)
        directionsButton.addTarget(self, action: #selector(directionsButtonPressed), for: .touchUpInside)
        return directionsButton
    }()
    
    let searchImageView : UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        searchImageView.image = UIImage(systemName: "magnifyingglass")!
        return searchImageView
    }()
    
    let directionsImageView : UIImageView = {
        let directionsImageView = UIImageView()
        directionsImageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        directionsImageView.image = UIImage(systemName: "eye.circle")!
        return directionsImageView
    }()
    
    lazy var leftBackgroundView : UIView = {
        let leftBackgroundView = UIView(frame: CGRect(x: self.bounds.width - 40, y: 0, width: 30, height: self.bounds.height))
        leftBackgroundView.layer.cornerRadius = 10
        leftBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        return leftBackgroundView
    }()
    
    let rightBackgroundView : UIView = {
        let rightBackgroundView = UIView()
        rightBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        rightBackgroundView.layer.cornerRadius = 10
        return rightBackgroundView
    }()
    
    var initialFrame: CGRect
    var extendedFrame: CGRect
    var droppedDownFrame : CGRect
    var isExtended = false
    var isDroppedDown = false
    
    
    init(frame: CGRect, extendedFrame: CGRect, droppedDownFrame: CGRect) {
        self.initialFrame = frame
        self.extendedFrame = extendedFrame
        self.droppedDownFrame = droppedDownFrame
        super.init(frame: frame)
        self.setInitialFrame()
        self.reloadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInitialFrame()
    {
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
            self.frame = self.extendedFrame
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
            self.frame = self.initialFrame
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
            self.frame = self.droppedDownFrame
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
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.extendedFrame
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
    var viewController : InteractiveMapViewController
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
    
    init(vc: InteractiveMapViewController) {
        self.viewController = vc
        super.init(frame: vc.view.frame)
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
        self.searchBarTableView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height * 8.5 / 10)
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
        for annotation in self.viewController.selectedGraph.vertices.map({ $0.value })
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
        cell.label.font = UIFont(name: "markerfelt-wide", size: 15)
        cell.backgroundColor = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrailSelectorTableViewCell{
            switch currentTextFieldType
            {
            case .destination:
                viewController.selectedTrail(origin: self.selectedOrigin, destination: cell.cellTrail!)
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


