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
    var trailReportsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        getUsersTrailReports()
    }
    private func getUsersTrailReports()
    {
        guard let currentUserId = InteractiveMapViewController.currentUser?.id else {
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
            self.configureTableView()
            self.trailReportsTableView.reloadData()
        })
    }
    private func getSingleUserTrailReports(id: String, completion: @escaping (Result<[TrailReport], Error>) -> Void) {
        let url = URL(string: "http://localhost:8080/api/users/\(id)/trail-reports")!
        
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
    private func configureTableView()
    {
        trailReportsTableView.layer.cornerRadius = 15
        trailReportsTableView.delegate = self
        trailReportsTableView.dataSource = self
        trailReportsTableView.backgroundColor = UIColor(hex: "#00000000")
        trailReportsTableView.frame = CGRect(x: 20, y: view.bounds.height/5, width: view.bounds.width - 40, height: view.bounds.height - view.bounds.height/5)
        trailReportsTableView.register(TrailReportTableViewCell.self, forCellReuseIdentifier: "trailReportTableViewCell")
        view.addSubview(trailReportsTableView)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TrailReportTableViewCell
        print("hello")
    }
    
}
