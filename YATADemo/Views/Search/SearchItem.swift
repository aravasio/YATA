//
//  SearchItem.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 14/09/2022.
//

import SwiftUI

struct SearchItem: View {
    var url: URL?
    var title: String
    var author: String
    var body: some View {
        Button(action: { },
               label: {
            AsyncImage(url: url,
                       content: { $0.resizable().padding(0) },
                       placeholder: { Text("loading ...") })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        })
        .padding(0)
        .overlay(PhotoOverlay(title: title, author: author), alignment: .bottomLeading)
        .buttonStyle(.plain)
    }
}

struct SearchItem_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "some_string_url")
        FeedItem(url: url, title: "Some Lorem Ipsum Generic Title", author: "AUTHOR NAME")
    }
}
