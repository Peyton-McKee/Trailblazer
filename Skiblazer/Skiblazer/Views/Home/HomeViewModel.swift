//
//  HomeViewModel.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/6/24.
//

import Amplify
import SwiftUI

struct HomeProps {}

class HomeViewModel: LoadableObject {
    @Published var state: LoadingState<HomeProps> = .idle
    @Published var isSignedIn = false
    @Published var currentUser: AuthUser?
    
    func load() {
        self.transitionState(.loading)
        Task {
            do {
                let currentSession = try await Amplify.Auth.fetchAuthSession()
                if currentSession.isSignedIn {
                    let currentUser  = try await Amplify.Auth.getCurrentUser()
                    DispatchQueue.main.async {
                        self.currentUser = currentUser
                    }
                }
                
                DispatchQueue.main.async {
                    self.isSignedIn = currentSession.isSignedIn
                    self.load(.init())
                }
            } catch {
                self.fail(error)
            }
        }
    }
    
    func signOut() {
        self.transitionState(.loading)
        Task {
            _ = await Amplify.Auth.signOut()
            self.isSignedIn = false
            self.currentUser = nil
            self.load(.init())
        }
    }
}
