//
//  FeedRequest.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 09/09/2022.
//

import Foundation
import Combine

class FeedRequest: Request {
    @Published var page: GalleryPage?
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
    
    func next() {
        if hasNextpage {
            pageNumber += 1
            fetch()
        }
    }
    
    func fetch() {
        request(urlPath)?
            .mapError({ (error) -> Error in
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [unowned self] response in
                self.page = response.page
            })
            .store(in: &cancellables)
    }
    
    private func request(_ path: String) -> AnyPublisher<FeedResponse, Error>? {
        guard let url = URL(string: urlPath) else { return nil }
        let request = URLRequest(url: url)
        
        return RequestAPI.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
