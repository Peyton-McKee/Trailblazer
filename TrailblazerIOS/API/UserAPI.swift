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
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/users")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let users = try decoder.decode([User].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(users))
                    }
            } catch {
                print("could not get all users")
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
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
  

    func updateUser(_ user: User, id: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(Self.baseURL)/api/users/\(id)")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } catch {
                completion(.failure(error))
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
                completion(.failure(error!))
                return
            }
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch{
                completion(.failure(error))
            }
        }.resume()
    }
}
