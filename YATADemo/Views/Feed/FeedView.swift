//
//  FeedView.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 30/08/2022.
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = Feed(startPage: 1, perPage: 10)

    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 5) {
                ForEach(viewModel.photos, id: \.id) { photo in
                    FeedItem(url: photo.url, title: photo.title, author: photo.ownerName)
                        .padding(15)
                        .onAppear {
                            if let last = viewModel.photos.last, photo.id == last.id {
                                viewModel.getData()
                            }
                        }
                }
            }
        }
        .onAppear {
            viewModel.getData()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
