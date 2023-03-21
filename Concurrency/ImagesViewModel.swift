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
    
    
    func downloadImages() async {
        ///    https://www.andyibanez.com/posts/file-download-queue-combine/
        ///    This was very intresting
        imageUrls
            .publisher  /// Returns each link
            .compactMap { URL(string: $0) } /// Will ignore nill values and returns URL
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
            }   /// Will turn
            .compactMap { $0.data } /// Will return data. CompactMap will remove nill values.
            .compactMap { UIImage(data: $0) }   /// Again using Compactmap we get rid of nill values and return image
            .retry(5)   /// Only try 5 times to download and return image, if you fail more than 5 times. Just stop
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
   
