//
//  MainViewModelResponse.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 09/09/2022.
//

import Foundation
import Combine

struct MainViewModelResponse: Codable {
    struct Extra: Codable {
        var explore_date: String
        var next_prelude_interval: Int
    }
    
    var page: GalleryPage
    var extra: Extra
    
    enum CodingKeys: String, CodingKey {
        case page = "photos"
        case extra
    }
}
