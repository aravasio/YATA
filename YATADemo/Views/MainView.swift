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
    @State private var currentSegment: MainSegmentedControlSelection = .feed
    
    var body: some View {
        NavigationView {
            TabView(selection: $currentSegment) {
                FeedView()
                    .navigationBarTitle(MainSegmentedControlSelection.feed.rawValue)
                    .navigationBarHidden(true)
                    .tabItem{
                        Text(MainSegmentedControlSelection.feed.rawValue)
                    }
                    .tag(MainSegmentedControlSelection.feed)
                
                SearchView()
                    .navigationBarTitle(MainSegmentedControlSelection.search.rawValue)
                    .navigationBarHidden(true)
                    .tabItem{
                        Text(MainSegmentedControlSelection.search.rawValue)
                    }
                    .tag(MainSegmentedControlSelection.search)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
