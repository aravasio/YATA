//
//  SearchResponse.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 14/09/2022.
//


import Foundation
import Combine

struct SearchResponse: Codable {
    var page: GalleryPage
    
    enum CodingKeys: String, CodingKey {
        case page = "photos"
    }
}
