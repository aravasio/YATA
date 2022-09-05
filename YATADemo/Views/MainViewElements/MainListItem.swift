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
    var image: Image
    var title: String
    var body: some View {
        Button(action: { },
               label: {
            ZStack {
                image
                    .background(.blue)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 150)
        })
        .overlay(PhotoViewOverlay(text: title), alignment: .bottomLeading)
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        MainListItem(image: Image("CERO"), title: "Test_title")
    }
}
