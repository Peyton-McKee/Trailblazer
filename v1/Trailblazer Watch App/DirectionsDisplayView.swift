//
//  DirectionsDisplayView.swift
//  Trailblazer Watch App
//
//  Created by Peyton McKee on 12/1/22.
//

import Foundation
import SwiftUI

struct DirectionsDisplayView: View {
    //@ObservedObject private var connectivityController = ConnectivityController.shared
    @ObservedObject private var connectivity = Connectivity.shared
    var body: some View {
        List{
            ForEach(connectivity.routeName, id: \.self) {
                name in
                Text(name)
            }
        }
    }
}

struct DirectionsDisplayView_Previews: PreviewProvider
{    
    static var previews: some View{
        DirectionsDisplayView()
    }
}
