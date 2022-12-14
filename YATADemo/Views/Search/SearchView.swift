//
//  SearchView.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 14/09/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = Search(startPage: 1, perPage: 10)
    @State private var currentSearchText: String = ""
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, spacing: 5) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        SearchItem(url: photo.url, title: photo.title, author: photo.ownerName)
                            .padding(15)
                            .onAppear {
                                if let last = viewModel.photos.last, photo.id == last.id {
                                    Task {
                                        await viewModel.getMorePhotos()
                                    }
                                }
                            }
                    }
                }
            }
            .searchable(text: $viewModel.currentQuery)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
