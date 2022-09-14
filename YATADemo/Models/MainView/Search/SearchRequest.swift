//
//  SearchRequest.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 14/09/2022.
//

import Foundation
import Combine

class SearchRequest: Request {
    @Published var page: GalleryPage?
    var cancellables = Set<AnyCancellable>()
    
    let baseUrl: String = "https://www.flickr.com/services/rest"
    let method: String = "/?method=flickr.photos.search"
    let apiKey: String = "&api_key=3e797d93e76acc6a616ab670e5d8a308"
    let extrasParam: String = "&extras=owner_name,date_taken"
    let formatParam = "&format=json&nojsoncallback=1"
    var perPageParam: String {
        "&per_page=\(perPage)"
    }
    var currentPageParam: String {
        "&page=\(pageNumber)"
    }
    var currentQueryParam: String {
        let percentEncodedString = currentQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? currentQuery
        return "&text=\(percentEncodedString)"
    }
    
    private let searchJsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    private let session = URLSession.shared
    private let startPage: Int
    private let perPage: Int
    private var pageNumber: Int
    private var currentQuery: String
    
    private var urlPath: String {
        baseUrl + method + apiKey + extrasParam + perPageParam + currentPageParam + formatParam + currentQueryParam
    }
    
    private var hasNextpage: Bool {
        let totalPages = page?.pages ?? 0
        return pageNumber + 1 <= totalPages
    }
    
    init(startPage: Int, perPage: Int) {
        self.startPage = startPage
        self.pageNumber = startPage
        self.perPage = perPage
        self.currentQuery = ""
    }
    
    func next() async -> [Photo] {
        do {
            if hasNextpage {
                pageNumber += 1
                return try await fetch(currentQuery)?.photos ?? []
            } else {
                pageNumber -= 1
                return []
            }
        }
        catch {
            print(error)
            page = nil
            return []
        }
    }
    
    func new(_ query: String) async -> [Photo] {
        do {
            currentQuery = query
            return try await fetch(currentQuery)?.photos ?? []
        }
        catch {
            print(error)
            page = nil
            return []
        }
    }
    
    private func fetch(_ query: String) async throws -> GalleryPage? {
        guard let url = URL(string: urlPath) else {
            throw generateError(description: "Couldn't format URL to query")
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
        case (200...299), (400...499):
            let result = try JSONDecoder().decode(SearchResponse.self, from: data).page
            self.page = result
            return result
        default:
            throw generateError(description: "A server error occured")
        }
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
    
}
