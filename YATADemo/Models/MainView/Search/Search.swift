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
    
    fileprivate func subscribeToDataChange() {
        request
            .$page
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] page in
                guard let newPhotos = page?.photos else { return }
                self?.photos.append(contentsOf: newPhotos)
            })
            .store(in: &cancellable)
    }
    
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
        subscribeToDataChange()
    }
    
    func query(_ query: String) async {
        photos = await request.new(query: query)
    }
    
    func fetch() {
        print("did call fetch")
        //        photos.isEmpty ? request.fetch() : request.next()
    }
}

