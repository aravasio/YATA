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
    var ownerName: String
    var dateTaken: String
    var secret: String
    var server: String
    var title: String
    var url: URL? {
        URL(string: "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case ownerName = "ownername"
        case dateTaken = "datetaken"
        case secret
        case server
        case title
    }
}
