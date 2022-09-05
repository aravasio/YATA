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
    var url: String {
        // TODO: Implement this URL & add fetch mechanism
        let baseUrl = "base.com"
        let params = "/image/\(id)"
        return baseUrl + params
    }
    
    // TODO: Implement placeholder + fetch image as observable, maybe? So while fetching show placeholder,
    // and then update on completion.
}
