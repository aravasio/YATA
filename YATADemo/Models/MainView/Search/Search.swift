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
    
    var cancellable = Set<AnyCancellable>()
    var request = SearchRequest(startPage: 1, perPage: 10)
    
    fileprivate func subscribeToQueryChanges() {
        $currentQuery.sink(receiveValue: { newValue in
            Task {
                if !newValue.isEmpty {
                    await self.query(newValue)
                }
            }
        })
        .store(in: &cancellable)
    }
    
    init() {
        subscribeToQueryChanges()
    }
    
    func query(_ query: String) async {
        photos = await request.new(query)
    }
    
    func getMorePhotos() async {
        photos += await request.next()
    }
}

