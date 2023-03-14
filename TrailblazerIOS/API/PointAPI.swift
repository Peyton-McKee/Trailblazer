//
//  PointAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    func updatePointTime(point: PointTimeUpdateData, completion: @escaping (Result<Point, Error>) -> Void)
    {
        let url = URL(string: "\(Self.baseURL)/api/users/\(point.id)")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(point)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let point = try? decoder.decode(Point.self, from: data) {
                    completion(.success(point))
                } else {
                    completion(.failure(DecodingErrors.pointDecodingError))
                    print("Could not update user")
                }
            }
        }.resume()
    }
}
