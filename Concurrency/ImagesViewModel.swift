//
//  ConcurrencyViewModel.swift
//  Concurrency
//
//  Created by Noujan Fakhri on 3/9/23.
//

import SwiftUI
import Combine

class ImagesViewModel: ObservableObject {
    private let imageUrls: [String]
    private let downloadQueue = DispatchQueue(label: "Download queue", qos: .background)
    var subscriptions = Set<AnyCancellable>()

    @Published var images: [UIImage] = []
    
    init() {
        imageUrls = [
            "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
            "https://i.imgur.com/MLKrFQ0.jpeg",
            "https://i.imgur.com/vsdcIJc.jpeg",
            "https://i.imgur.com/0UB7USl.jpeg"
        ]
    }
    
    
    func downloadImages() {
        imageUrls
            .publisher
            .compactMap { URL(string: $0) }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
            }
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .sink(receiveCompletion: ( { state in
                // Handle completion here
            })) { output in
                // Each image will be received here. You can do whatever you want with it.
                // uiImages += [output]
                self.images.append(output)
            }
            .store(in: &subscriptions)
    }
   
}
   
