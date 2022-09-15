//
//  PhotoOverlay.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 14/09/2022.
//

import SwiftUI

struct PhotoOverlay: View {
    var title: String
    var author: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.callout)
                .padding(15)
                .background(.black.opacity(0.4))
                .foregroundColor(.white)
            
            Text(author)
                .font(.callout)
                .padding(15)
                .background(.black.opacity(0.4))
                .foregroundColor(.white)
        }
    }
}

struct PhotoOverlay_Previews: PreviewProvider {
    static var previews: some View {
        PhotoOverlay(title: "title_field", author: "author_field")
    }
}
