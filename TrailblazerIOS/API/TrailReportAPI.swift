//
//  TrailReportAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    /// getTrailReports: void -> [TrailReport] || Error
    /// gets all the trail reports being stored on the database
    func getTrailReports(completion: @escaping (Result<[TrailReport], Error>) -> Void) {
        let url = URL(string: "\(self.baseURL)/api/trail-reports")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let trailReports = try? decoder.decode([TrailReport].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(trailReports))
                }
            } else {
                print("Unable to parse JSON response for getting trail reports")
                completion(.failure(error!))
            }
        }.resume()
    }
    
    public func deleteTrailReport(id: String?)
    {
        guard let id = id else
        {
            //its a local trail report
            return
        }
        let url = URL(string: "\(self.baseURL)/api/trail-reports/\(id)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response.suggestedFilename ?? "ahhh")
            } else
            {
                print("Bad JSON received back for deleting trail report")
            }
        }.resume()
    }
    
    /// saveTrailReport: TrailReport -> void
    /// parameters:
    /// - trailReport: the trail report to be sent to the database
    /// sends the given trail report to the database
    func saveTrailReporrt(_ trailReport: TrailReport) {
        let url = URL(string: "\(self.baseURL)/api/trail-reports")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(trailReport)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let item = try? decoder.decode(TrailReport.self, from: data) {
                    print(item.type)
                } else {
                    print(data)
                    print("Bad JSON received back for saving trail report.")
                }
            }
        }.resume()
    }
    
    func getSingleUserTrailReports(id: String, completion: @escaping (Result<[TrailReport], Error>) -> Void) {
        let url = URL(string: "\(self.baseURL)/api/users/\(id)/trail-reports")!
        
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
            }
        }.resume()
    }
}
