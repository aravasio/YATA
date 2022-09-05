//
//  MainListView.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 30/08/2022.
//

import SwiftUI

struct MainListView: View {
    @Binding var listStyle: MainSegmentedControlSelection
    @Binding var gallery: Gallery?
    @State private var currentSearchText: String = ""
    
    @State private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var feedList: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, spacing: 5) {
                var aux = gallery?.photos ?? []
                ForEach(gallery?.photos ?? [], id: \.self) { element in
                    if currentSearchText.isEmpty || element.title.lowercased().contains(currentSearchText.lowercased()) {
                        let photo: Photo = aux.removeFirst()
                        let image = Image(photo.url)
                        MainListItem(image: image, title: photo.title)
                    }
                }
            }
        }
    }
    
    var searchableFeedList: some View {
        feedList
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
        let gallery = Gallery(page: 1, pages: 1, perpage: 1, total: 1, photos: [photo])
        MainListView(listStyle: .constant(.feed), gallery: .constant(gallery))
    }
}
