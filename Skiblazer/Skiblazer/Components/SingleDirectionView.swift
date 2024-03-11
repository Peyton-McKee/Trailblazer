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
            return .init(systemName: SystemImageName.turn.rawValue)!
        case .right:
            let turnImage = UIImage(systemName: SystemImageName.turn.rawValue)!
            return UIImage(cgImage: turnImage.cgImage!, scale: turnImage.scale, orientation: .upMirrored)
        case .straight:
            return .init(systemName: SystemImageName.straight.rawValue)!
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
                    .foregroundStyle(.primary)
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)

                let feet = round(Double(self.distanceToUpcomingKeyAnnotation * 3.28084) / 100) * 100
                Text("\(feet < 1000 ? feet : self.distanceToUpcomingKeyAnnotation * 0.000621371, specifier: "\(feet < 1000 ? "%.0f" : "%0.1f")") \(feet < 1000 ? "feet" : "miles")")
            }
        }
    }
}
