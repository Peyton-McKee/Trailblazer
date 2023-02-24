//
//  MapAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

func getMaps(completion: @escaping (Result<[Map], Error>) -> Void)
{
    let url = URL(string: "\(getBaseUrl())/api/maps")!
    
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
