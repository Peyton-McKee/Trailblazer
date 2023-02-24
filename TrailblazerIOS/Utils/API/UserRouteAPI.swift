//
//  UserRouteAPI.swift
//  Trailblazer
//
//  Created by Peyton McKee on 2/24/23.
//

import Foundation


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
                print("Bad JSON received back for saving user route.")
            }
        }
    }.resume()
}
