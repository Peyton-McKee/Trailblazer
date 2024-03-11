//
//  MapAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    func getMaps(completion: @escaping (Result<[MapPreview], Error>) -> Void)
    {
        let url = URL(string: "\(self.baseURL)/api/maps")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let maps = try decoder.decode([MapPreview].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(maps))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getMap(id: String, completion: @escaping (Result<Map, Error>) -> Void) {
        let url = URL(string: "\(self.baseURL)/api/maps/\(id)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let map = try decoder.decode(Map.self, from: data)
                completion(.success(map))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getMapTrails(mapId: String, completion: @escaping (Result<[MapTrail], Error>) -> Void) {
        let url = URL(string: "\(self.baseURL)/api/maps/\(mapId)/map-trails")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let mapTrails = try decoder.decode([MapTrail].self, from: data)
                completion(.success(mapTrails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getMapConnectors(mapId: String, completion: @escaping (Result<[MapConnector], Error>) -> Void) {
        let url = URL(string: "\(self.baseURL)/api/maps\(mapId)/map-connectors")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }

            let decoder = JSONDecoder()

            do {
                let mapConnectors = try decoder.decode([MapConnector].self, from: data)
                completion(.success(mapConnectors))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getPoints(id: String, isConnector: Bool, completion: @escaping (Result<[Point], Error>) -> Void) {
        var url: URL
        switch isConnector {
        case true:
            url = URL(string: "\(self.baseURL)/api/map-connectors/\(id)/points")!
        case false:
            url = URL(string: "\(self.baseURL)/api/map-trails/\(id)/points")!
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }

            let decoder = JSONDecoder()
            do {
                let points = try decoder.decode([Point].self, from: data)
                completion(.success(points.sorted(by: { $0.order < $1.order })))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
