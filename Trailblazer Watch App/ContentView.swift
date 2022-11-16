//
//  ContentView.swift
//  Trailblazer Watch App
//
//  Created by Peyton McKee on 11/8/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject private var connectivityController = ConnectivityController.shared
    
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.46806937533083, longitude: -70.87985973100996),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.1))
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .frame(width: 200, height: 200)
//        List {
//            ForEach(connectivityController.route) {
//                route in
//                Text(verbatim: route.annotationName)
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
