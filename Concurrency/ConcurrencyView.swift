//
//  ContentView.swift
//  Concurrency
//
//  Created by Noujan Fakhri on 3/9/23.
//

import SwiftUI

struct ConcurrencyView: View {
    @ObservedObject var viewModel = ImagesViewModel()
    
    var body: some View {
        List(viewModel.images, id: \.self) { image in
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
        .task {
            do {
                try await viewModel.downloadImages()
                // Images have been downloaded successfully

            } catch {
                // Handle any errors that may have occurred during image download
                print(error)
            }
        }
    }
}

struct ConcurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        ConcurrencyView()
    }
}
