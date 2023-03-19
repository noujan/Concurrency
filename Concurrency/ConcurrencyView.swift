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
            await viewModel.downloadImages()
        }
    }
}

struct ConcurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        ConcurrencyView()
    }
}
