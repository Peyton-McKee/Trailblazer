//
//  DatabaseAccessors.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/5/22.
//

import Foundation

func getBaseUrl() -> String
{
    return "http://35.172.135.117"
    
}
/// saveTrailReport: TrailReport -> void
/// parameters:
/// - trailReport: the trail report to be sent to the database
/// sends the given trail report to the database
func saveTrailReporrt(_ trailReport: TrailReport) {
    let url = URL(string: "\(getBaseUrl())/api/trail-reports")!
    
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

func getSingleUser(id: String, completion: @escaping (Result<User, Error>) -> Void) {
    let url = URL(string: "\(getBaseUrl())/api/users/\(id)")!
    
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
            print("Unable to decode user")
            return
        }
        
    }.resume()
}
/// getTrailReports: void -> [TrailReport] || Error
/// gets all the trail reports being stored on the database
func getTrailReports(completion: @escaping (Result<[TrailReport], Error>) -> Void) {
    let url = URL(string: "\(getBaseUrl())/api/trail-reports")!
    
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
func saveUserRoute(_ userRoute: UserRoute) {
    let url = URL(string: "\(getBaseUrl())/api/user-routes/")!
    
    let encoder = JSONEncoder()
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? encoder.encode(userRoute)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            let decoder = JSONDecoder()
            if let item = try? decoder.decode(UserRoute.self, from: data) {
                print(item.destinationTrailName)
            } else {
                print(data)
                print("Bad JSON received back for saving user route.")
            }
        }
    }.resume()
}
func saveUserLocation(_ userLocation: UserLocation) {
    let url = URL(string: "\(getBaseUrl())/api/user-locations")!
    
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
                print(data)
                print("Bad JSON received back for saving user location.")
            }
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
    let url = URL(string: "\(getBaseUrl())/api/trail-reports/\(id)")!
    
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

func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
    let url = URL(string: "\(getBaseUrl())/api/users")!
    
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
            completion(.failure(error!))
        }
    }.resume()
}

func saveUser(_ user: User) {
    let url = URL(string: "\(getBaseUrl())/api/users")!
    
    let encoder = JSONEncoder()
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? encoder.encode(user)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.userName)
                InteractiveMapViewController.currentUser = user
                
                
            } else {
                print("Could not save user")
            }
        }
    }.resume()
}

func updateUser(_ user: User) {
    guard let id = user.id else { print("User does not have Id"); return }
    let url = URL(string: "\(getBaseUrl())/api/users/\(id)")!
    
    let encoder = JSONEncoder()
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? encoder.encode(user)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                print(user.userName)
                
            } else {
                print("Could not update user")
            }
        }
    }.resume()
}
