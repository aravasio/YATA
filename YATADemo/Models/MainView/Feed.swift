//
//  Feed.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation
import Combine
import SwiftUI

class Feed: ObservableObject {
    @Published var photos: [Photo] = []
    @Published private var page: GalleryPage?
    
    var cancellables = Set<AnyCancellable>()
    
    let baseUrl: String = "https://www.flickr.com/services/rest"
    let method: String = "/?method=flickr.interestingness.getList"
    let apiKey: String = "&api_key=3e797d93e76acc6a616ab670e5d8a308"
    let extrasParam: String = "&extras=owner_name,date_taken"
    let formatParam = "&format=json&nojsoncallback=1"
    var perPageParam: String {
        "&per_page=\(perPage)"
    }
    var currentPageParam: String {
        return "&page=\(pageNumber)"
    }
    
    private let startPage: Int
    private let perPage: Int
    private var pageNumber: Int
    
    private var urlPath: String {
        baseUrl + method + apiKey + extrasParam + perPageParam + currentPageParam + formatParam
    }
    
    private var hasNextpage: Bool {
        let totalPages = page?.pages ?? 0
        return pageNumber + 1 <= totalPages
    }
    
    init(startPage: Int, perPage: Int) {
        self.startPage = startPage
        self.pageNumber = startPage
        self.perPage = perPage
    }
    
    func getData() {
        photos.isEmpty ? fetch() : next()
    }
    
    private func next() {
        if hasNextpage {
            pageNumber += 1
            fetch()
        }
    }
    
    private func fetch() {
        request(urlPath, responseType: FlickrResponse.self)?
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                if !$0.page.photos.isEmpty {
                    self.page = $0.page
                    self.photos.append(contentsOf: $0.page.photos)
                }
            })
            .store(in: &cancellables)
    }
    
    private func request<R: Decodable>(_ path: String, responseType: R.Type) -> AnyPublisher<R, Error>? {
        guard let url = URL(string: urlPath) else { return nil }
        let request = URLRequest(url: url)
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> R in
                return try JSONDecoder().decode(R.self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "YATAFeed", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}

