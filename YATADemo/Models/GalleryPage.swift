//
//  GalleryPage.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation

struct GalleryPage: Codable, Hashable {
    var pageNumber: Int
    var pages: Int
    var perpage: Int
    var total: Int
    var photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case pages
        case perpage
        case total
        case photos = "photo"
    }
}
