//
//  MainViewModel.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 05/09/2022.
//

import Foundation
import Combine
import SwiftUI

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

