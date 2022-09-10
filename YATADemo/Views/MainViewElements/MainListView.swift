//
//  MainListView.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 30/08/2022.
//

import SwiftUI

struct MainListView: View {
    @Binding var listStyle: MainSegmentedControlSelection
    @Binding var photos: [Photo]
    @State private var currentSearchText: String = ""
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
    var nextPageHandler: (() -> ())? = nil
    
    var feedList: some View {
        LazyVGrid(columns: gridItemLayout, spacing: 5) {
            ForEach(photos, id: \.id) { photo in
                if let last = photos.last, photo.id == last.id {
                    MainListItem(url: photo.url, title: photo.title)
                        .padding(15)
                        .background(Color.red)
                        .onAppear {
                            nextPageHandler?()
                        }
                } else {
                    MainListItem(url: photo.url, title: photo.title)
                        .padding(15)
                }
            }
        }
    }
    
    var searchableFeedList: some View {
        Text("que copado todo esto")
//        feedList
        /// Some UI / Scroll / VoiceInput issues
        /// better luck later on.
//            .searchable(text: $currentSearchText, prompt: "type something to search")
    }
    
    var body: some View {
        if listStyle == .feed {
            feedList
        } else {
            searchableFeedList
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        let photo = Photo(id: "1", owner: "asd", secret: "asdasdad", server: "asdasdasd", title: "Photo Test Title")
        let gallery = GalleryPage(pageNumber: 1, pages: 1, perpage: 1, total: 1, photos: [photo])
        MainListView(listStyle: .constant(.feed), photos: .constant(gallery.photos))
    }
}
