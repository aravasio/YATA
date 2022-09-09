//
//  MainViewModelRequest.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 09/09/2022.
//

import Foundation
import Combine

class MainViewModelRequest: Request {
    @Published var page: GalleryPage?
    var cancellables = Set<AnyCancellable>()

    let baseUrl: String = "https://www.flickr.com/services/rest"
    let method: String = "/?method=flickr.interestingness.getList"
    let apiKey: String = "&api_key=3e797d93e76acc6a616ab670e5d8a308"
    let extrasParam: String = "&extras=owner_name"
    let formatParam = "&format=json&nojsoncallback=1"
    var perPageParam: String {
        "&per_page=\(perPage)"
    }
    var currentPageParam: String {
        let pageNumber = page?.pageNumber ?? 1
        return "&page=\(pageNumber)"
    }

    private var startPage: Int
    private var perPage: Int
    
    private var urlPath: String {
        baseUrl + method + apiKey + extrasParam + perPageParam + currentPageParam + formatParam
    }
    
    init(startPage: Int, perPage: Int) {
        self.startPage = startPage
        self.perPage = perPage
    }
    
    func next() {
        page?.pageNumber += 1
        fetch()
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
    
    private func request(_ path: String) -> AnyPublisher<MainViewModelResponse, Error>? {
        guard let url = URL(string: urlPath) else { return nil }
        let request = URLRequest(url: url)
        
        return RequestAPI.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
