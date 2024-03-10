//
//  SingleDirectionView.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/9/24.
//

import SwiftUI

struct SingleDirectionView: View {
    var direction: Direction

    var upcomingPoint: Point
    var currentLocation: Point

    var image: UIImage {
        switch self.direction {
        case .left:
            let turnImage = UIImage(systemName: SystemImageName.turn.rawValue)!
            return UIImage(cgImage: turnImage.cgImage!, scale: turnImage.scale, orientation: .upMirrored).withTintColor(.systemBlue)
        case .right:
            return .init(systemName: SystemImageName.turn.rawValue)!.withTintColor(.systemBlue)
        case .straight:
            return .init(systemName: SystemImageName.straight.rawValue)!.withTintColor(.systemBlue)
        }
    }

    var distanceToUpcomingKeyAnnotation: Double {
        return self.upcomingPoint.coordinate.distance(to: self.currentLocation.coordinate)
    }

    var body: some View {
        HStack {
            SkiblazerLabel(self.upcomingPoint.title)
                .bold()

            Spacer()

            VStack {
                Image(uiImage: self.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                Text("\(self.distanceToUpcomingKeyAnnotation * 3.28084, specifier: "%.0f") feet")
            }
        }
    }
}
