//
//  AsyncImageLoaderModel.swift
//  Snowport
//
//  Created by Peyton McKee on 1/8/24.
//

import SwiftUI
import Amplify

struct AsyncImageProps {
    var image: UIImage
}

class AsyncImageLoaderModel: LoadableObject {
    @Published var state: LoadingState<AsyncImageProps> = .idle
    var image: UIImage?
    var imageKey: String?
    var squareImageId: String?
    var oauthToken: String?
    
    var cachedProps: AsyncImageProps {
        guard let image = self.image else {
            return .init(image: .init(systemName: SystemImageName.questionMark.rawValue)!)
        }
        
        return .init(image: image)
    }
    init(image: UIImage) {
        self.image = image
    }
    
    init(imageKey: String) {
        self.imageKey = imageKey
    }
    
    init(squareImageId: String, oauthToken: String) {
        self.squareImageId = squareImageId
        self.oauthToken = oauthToken
    }
    
    func load() {
        self.transitionState(.loadingAsyncImage)
        if let image = self.image {
            self.transitionState(.loaded(.init(image: image)))
            return
        }
        
        guard let imageKey = self.imageKey else {
            return
        }
        
        Task {
            do {
                let image = try await APIHandler.downloadImage(imageKey)
                self.image = image
                self.load(self.cachedProps)
            } catch {
                self.fail(error, self.cachedProps)
            }
        }
    }
}

