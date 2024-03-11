//
//  UserLocationAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    func saveUserLocation(_ userLocation: UserLocation) {
        let url = URL(string: "\(self.baseURL)/api/user-locations")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(userLocation)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if (try? decoder.decode(UserLocation.self, from: data)) != nil {
                    
                } else {
                    print("Bad JSON received back for saving user location.")
                }
            }
        }.resume()
    }
    
    func getUserLocationsWith(_ id: String, completion: @escaping (Result<[UserLocation], Error>) -> Void) {
        let url = URL(string: "\(self.baseURL)/api/users/\(id)/user-locations")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error!.localizedDescription)
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            if let userLocations = try? decoder.decode([UserLocation].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(userLocations))
                }
            } else {
                print("Could not decode user locations")
                completion(.failure(DecodingErrors.userLocationDecodingError))
            }
        }
    }
}
