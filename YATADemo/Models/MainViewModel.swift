//
//  MainViewModel.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation
import Combine
import SwiftUI

fileprivate struct MainViewModelResponse: Codable {
    struct Extra: Codable {
        var explore_date: String
        var next_prelude_interval: Int
    }
    
    var gallery: Gallery
    var extra: Extra
    
    enum CodingKeys: String, CodingKey {
        case gallery = "photos"
        case extra
    }
}

class MainViewModel: ObservableObject {
    @Published var gallery: Gallery?
    var cancellationToken: AnyCancellable?
    
    private let baseUrl: String = "https://www.flickr.com/services/rest"
    private let getInterestingPhotosMethod: String = "/?method=flickr.interestingness.getList"
    private let apiKey: String = "&api_key=5e200797f4437780ce50f890fd62c453"
    private let formatParam = "&format=json&nojsoncallback=1&per_page=50"
    private var urlPath: String {
        baseUrl + getInterestingPhotosMethod + apiKey + formatParam
    }
    
    init() {
        getImages()
    }
    
    func getImages() {
        cancellationToken = self.request(urlPath)?
            .mapError({ (error) -> Error in
                print(error)
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] newValue in
                self?.gallery = newValue.gallery
            })
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
