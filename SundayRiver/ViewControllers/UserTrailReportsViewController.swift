//
//  UserTrailReportsViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/25/22.
//

import Foundation
import UIKit

class UserTrailReportsViewController: UIViewController{
    var trailReports : [TrailReport]?
    var trailReportsTableView : UITableView = {
        var tableView = UITableView()
        tableView.layer.cornerRadius = 15
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrailReportTableViewCell.self, forCellReuseIdentifier: "trailReportTableViewCell")
        return tableView
    }()
    
    var myTrailReportLabel : UILabel = {
        let label = UILabel()
        label.text = "My Trail Reports"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "markerfelt-wide", size: 25)
        return label
    }()
    lazy var myVstack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        [self.myTrailReportLabel, self.trailReportsTableView].forEach{ stack.addArrangedSubview($0) }
        return stack
    }()
    let baseURL = "http://35.172.135.117"
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        getUsersTrailReports()
    }
    private func configureView()
    {
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 0.9)
        trailReportsTableView.delegate = self
        trailReportsTableView.dataSource = self
        trailReportsTableView.backgroundColor = UIColor(hex: "#00000000")
        view.addSubview(myVstack)
        NSLayoutConstraint.activate([myTrailReportLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30), trailReportsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor), myVstack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     myVstack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     myVstack.topAnchor.constraint(equalTo: myTrailReportLabel.topAnchor),
                                     myVstack.bottomAnchor.constraint(equalTo: trailReportsTableView.bottomAnchor),
                                     trailReportsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     trailReportsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
    private func getUsersTrailReports()
    {
        guard let currentUserId = InteractiveMapViewController.currentUser.id else {
            //user is a guest
            return
        }
        getSingleUserTrailReports(id: currentUserId, completion: { result in
            guard let userTrailReports = try? result.get() else {
                print("Error: \(result)")
                return
            }
            if userTrailReports.isEmpty
            {
                return
                //user has not made any trail reports
            }
            self.trailReports = userTrailReports
            self.trailReportsTableView.reloadData()
            
        })
    }
    private func getSingleUserTrailReports(id: String, completion: @escaping (Result<[TrailReport], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/users/\(id)/trail-reports")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let user = try? decoder.decode([TrailReport].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                print("Unable to parse JSON response.")
                completion(.failure(error!))
            }
        }.resume()
    }
}
extension UserTrailReportsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trailReports = self.trailReports else{ return 0 }
        return trailReports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trailReportTableViewCell", for: indexPath) as! TrailReportTableViewCell
        cell.layer.cornerRadius = 15
        cell.backgroundColor = .darkGray
        cell.cellTrailReport = trailReports![indexPath.row]
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
