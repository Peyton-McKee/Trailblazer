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
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            if let maps = try? decoder.decode([Map].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(maps))
                }
            } else {
                completion(.failure(DecodingErrors.mapDecodingError))
                return
            }
        }.resume()
    }
    
    func getMap(id: String, completion: @escaping (Result<Map, Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/maps/\(id)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            if let map = try? decoder.decode(Map.self, from: data) {
                completion(.success(map))
            } else {
                completion(.failure(DecodingErrors.mapDecodingError))
                return
            }
        }.resume()
    }
    
    private func getMapTrails(mapId: String, completion: @escaping (Result<[MapTrail], Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/maps/\(mapId)/map-trails")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()

            if let mapTrails = try? decoder.decode([MapTrail].self, from: data) {
                completion(.success(mapTrails))
            } else {
                completion(.failure(DecodingErrors.mapTrailDecdingError))
                return
            }
        }.resume()
    }
    
    private func getMapConnectors(mapId: String, completion: @escaping (Result<[MapConnector], Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/maps\(mapId)/map-connectors")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }

            let decoder = JSONDecoder()

            if let mapConnectors = try? decoder.decode([MapConnector].self, from: data) {
                completion(.success(mapConnectors))
            } else {
                completion(.failure(DecodingErrors.mapConnectorDecodingError))
                return
            }
        }.resume()
    }
    
    private func getPoints(id: String, isConnector: Bool, completion: @escaping (Result<[Point], Error>) -> Void) {
        var url: URL
        switch isConnector {
        case true:
            url = URL(string: "\(Self.baseURL)/api/map-connectors/\(id)/points")!
        case false:
            url = URL(string: "\(Self.baseURL)/api/map-trails/\(id)/points")!
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }

            let decoder = JSONDecoder()
            if let points = try? decoder.decode([Point].self, from: data) {
                completion(.success(points.sorted(by: { $0.order < $1.order })))
            } else {
                completion(.failure(DecodingErrors.pointDecodingError))
                return
            }
        }.resume()
    }
}
