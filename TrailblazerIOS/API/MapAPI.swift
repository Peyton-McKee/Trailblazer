//
//  MapAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    func getMaps(completion: @escaping (Result<[Map], Error>) -> Void)
    {
        let url = URL(string: "\(Self.baseURL)/api/maps")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let maps = try? decoder.decode([Map].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(maps))
                }
            } else {
                print("could not get all maps")
                completion(.failure(DecodingErrors.mapDecodingError))
            }
        }.resume()
    }
    
    func getMap(id: String, completion: @escaping (Result<Map, Error>) -> Void)
    {
        let url = URL(string: "\(Self.baseURL)/api/maps/\(id)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let map = try? decoder.decode(Map.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(map))
                }
            } else {
                print("could not get all maps")
                completion(.failure(DecodingErrors.mapDecodingError))
            }
        }.resume()
    }
}
