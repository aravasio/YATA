//
//  PhotoView.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 02/09/2022.
//

import SwiftUI

struct PhotoViewOverlay: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.callout)
            .padding(15)
            .background(.black.opacity(0.4))
            .padding(15)
            .foregroundColor(.white)
    }
}

struct MainListItem: View {
    var url: URL?
    var title: String
    var body: some View {
        Button(action: { },
               label: {
                AsyncImage(url: url,
                           content: { $0.resizable().padding(0) },
                           placeholder: { Text("loading ...") })
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        })
        .padding(0)
        .overlay(PhotoViewOverlay(text: title), alignment: .bottomLeading)
        .buttonStyle(.plain)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "some_string_url")
        MainListItem(url: url, title: "Test Title")
    }
}
