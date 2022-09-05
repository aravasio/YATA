//
//  Gallery.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation

struct Gallery: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photos = "photo"
    }
}
