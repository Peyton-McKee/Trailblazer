//
//  MapFileAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    func saveMapFile(mapFile: MapFile, completion: @escaping (Result<MapFile, Error>) -> Void)
    {
        let url = URL(string: "\(self.baseURL)/api/map-files")!
        
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(mapFile)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Could not save mapFile")
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let mapFile = try decoder.decode(MapFile.self, from: data)
                    completion(.success(mapFile))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
