//
//  HomePageView.swift
//  Trailblazer Watch App
//
//  Created by Peyton McKee on 12/1/22.
//

import Foundation
import SwiftUI

struct HomePageView : View {
    var body: some View{
        VStack{
            Text("Welcome To Trailblazer!")
            NavigationLink("See Current Route", destination: DirectionsDisplayView())
        }
    }
}
struct HomePage_Previews: PreviewProvider
{
    static var previews: some View {
        HomePageView()
    }
}
