//
//  DataManager.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation
import Combine
import SwiftUI

struct RequestAPI {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
