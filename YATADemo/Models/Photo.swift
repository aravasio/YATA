//
//  Photo.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 04/09/2022.
//

import Foundation

struct Photo: Codable, Hashable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var title: String
    var url: URL? {
        URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
}
