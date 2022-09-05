//
//  ContentView.swift
//  YATADemo
//
//  Created by Alejandro Ravasio on 30/08/2022.
//

import SwiftUI
import Combine



enum MainSegmentedControlSelection: String, CaseIterable {
    case feed = "FEED"
    case search = "SEARCH"
}

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    @State private var currentSegment: MainSegmentedControlSelection = .feed
        
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Picker("Segmented Control", selection: $currentSegment) {
                    ForEach(MainSegmentedControlSelection.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                mainList
            }
        }
    }
    
    var mainList: some View {
        ScrollView {
            MainListView(listStyle: $currentSegment, gallery: $viewModel.gallery)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}