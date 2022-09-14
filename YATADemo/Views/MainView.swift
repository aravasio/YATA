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
    @StateObject var feed = Feed()
    @State private var currentSegment: MainSegmentedControlSelection = .feed
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Picker("Segmented Control", selection: $currentSegment) {
                ForEach(MainSegmentedControlSelection.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            
            switch currentSegment {
            case .feed:
                FeedView()
            case .search:
                SearchView()
            }
            
            Spacer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
