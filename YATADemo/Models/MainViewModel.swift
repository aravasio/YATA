//
//  MainViewModel.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation
import Combine
import SwiftUI

enum Interestingness {
    case getList
    
    var methodPath: String {
        switch self {
        case .getList: return "/?method=flickr.interestingness.getList"
        }
    }
}

fileprivate struct MainViewModelResponse: Codable {
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

protocol Request: ObservableObject {
    var baseUrl: String { get }
    var method: String { get }
    var apiKey: String { get }
}

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
    
    // API request
    private func request(_ path: String) -> AnyPublisher<MainViewModelResponse, Error>? {
        guard let url = URL(string: urlPath) else { return nil }
        let request = URLRequest(url: url)
        
        return RequestAPI.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

class MainViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    
    var cancellable = Set<AnyCancellable>()
    var request = MainViewModelRequest(startPage: 1, perPage: 5)
    
    init() {
        request.fetch()
        request
            .$page
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] page in
                guard let newPhotos = page?.photos else { return }
                self?.photos.appendDistinct(contentsOf: newPhotos, where: { (first, second) in
                    first.id != second.id
                })
//                self!.photos.append(contentsOf: newPhotos)
            })
            .store(in: &cancellable)
    }
    
    func didTapDebug() {
        request.next()
    }
}

extension Array{
    public mutating func appendDistinct<S>(contentsOf newElements: S, where condition:@escaping (Element, Element) -> Bool) where S : Sequence, Element == S.Element {
      newElements.forEach { (item) in
        if !(self.contains(where: { (selfItem) -> Bool in
            return !condition(selfItem, item)
        })) {
            self.append(item)
        }
    }
  }
}
