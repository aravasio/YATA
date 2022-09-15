//
//  Search.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 14/09/2022.
//

import Foundation
import Combine
import SwiftUI

class Search: ObservableObject {
    @Published var currentQuery: String = ""
    @Published var photos: [Photo] = []
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
        subscribeToQueryChanges()
    }
    
    func getMorePhotos() async {
        do {
            if hasNextpage {
                pageNumber += 1
                photos += try await fetch(currentQuery)?.photos ?? []
            }
        }
        catch {
            print(error)
        }
    }
    
    private func subscribeToQueryChanges() {
        $currentQuery.sink(receiveValue: { query in
            Task { [unowned self] in
                if !query.isEmpty {
                    self.photos = await self.new(query)
                }
            }
        })
        .store(in: &cancellables)
    }
    
    private func new(_ query: String) async -> [Photo] {
        do {
            return try await fetch(currentQuery)?.photos ?? []
        }
        catch {
            print(error)
            return []
        }
    }
    
    private func fetch(_ query: String) async throws -> GalleryPage? {
        guard let url = URL(string: urlPath) else {
            throw generateError(description: "Couldn't format URL to query")
        }
        
        let (data, _) = try await session.data(from: url)
        let result = try JSONDecoder().decode(FlickrResponse.self, from: data).page
        self.page = result
        return result
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "YATASearch", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}

