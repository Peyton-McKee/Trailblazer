//
//  UserAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation

extension APIHandler {
    func getSingleUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/users/\(id)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                completion(.failure(DecodingErrors.userDecodingError))
                print("Unable to decode user")
            }
            
        }.resume()
    }
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/users")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let users = try? decoder.decode([User].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } else {
                print("could not get all users")
                completion(.failure(DecodingErrors.userDecodingError))
            }
        }.resume()
    }
    
    func saveUser(_ user: User, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/users")!
        
        let encoder = JSONEncoder()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Could not save user")
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                completion(.success(user))
            }
            else {
                print("Error Decoding user")
                completion(.failure(DecodingErrors.userDecodingError))
            }
        }.resume()
    }
    
    func updateUser(_ user: User) {
        guard let id = user.id else { print("User does not have Id"); return }
        let url = URL(string: "\(Self.baseURL)/api/users/\(id)")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(User.self, from: data) {
                    print(user.username)
                    
                } else {
                    print("Could not update user")
                }
            }
        }.resume()
    }
    
    func loginHandler(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    {
        let url = URL(string: "\(Self.baseURL)/api/users/login")!
        
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data){
                completion(.success(user))
            }
            else{
                print("Unable to decode user")
                completion(.failure(DecodingErrors.userDecodingError))
            }
        }.resume()
    }
}
