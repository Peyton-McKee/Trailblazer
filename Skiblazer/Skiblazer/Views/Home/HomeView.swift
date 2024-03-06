//
//  HomeView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Amplify
import Authenticator
import SwiftUI

struct HomeView: View {
    @State var path: [HomeNavigation] = []
    
    @ObservedObject var viewModel = HomeViewModel()

    var body: some View {
        AsyncContentView(source: self.viewModel) { _ in
            NavigationStack(path: self.$path) {
                ZStack {
                    Image(.srSun)
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        SkiblazerLabel("Skiblazer", fontSize: 36)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Group {
                            if self.viewModel.isSignedIn {
                                SkiblazerButton("Continue") {
                                    self.path.append(.mapSelector)
                                }
                                .frame(maxWidth: .infinity)
                                
                                SkiblazerButton("Sign Out") {
                                    self.viewModel.signOut()
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                SkiblazerButton("Sign In/Up") {
                                    self.path.append(.signUp)
                                }
                                .frame(maxWidth: .infinity)
                                
                                SkiblazerButton("Continue as Guest") {
                                    self.path.append(.mapSelector)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                        Spacer()
                            .frame(maxHeight: 100)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .navigationDestination(for: HomeNavigation.self) { destination in
                    switch destination {
                    case .signUp:
                        Authenticator { _ in
                            MapSelectorView(path: self.$path)
                        }
                    case .mapSelector:
                        MapSelectorView(path: self.$path)
                    case .mapView(let map):
                        SkiblazerMap(viewModel: .init(map: map))
                    case .admin:
                        AdminView()
                    }
                }
                .toolbar {
                    if self.viewModel.isSignedIn {
                        Button("", systemImage: SystemImageName.more.rawValue) {
                            self.path.append(.admin)
                        }
                    }
                }
            }
        }
    }
}
