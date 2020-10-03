//
//  SeasonsView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct SeasonsView: View {
    @StateObject var state = ViewState()
    
    var body: some View {
		List {
            ForEach(state.seasons) { season in
				NavigationLink(destination: SeasonView(season: season)) {
					Text(season.name)
				}
			}
        }.navigationBarTitle("Seasons").onAppear(perform: state.load)
    }
}

extension SeasonsView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var seasons = [RaceSeason]()
        
        var cancellables = [AnyCancellable]()
        
        func load () {
            guard seasons.isEmpty else { return }
            skylark.getSeasons().map(\.objects).receive(on: DispatchQueue.main).sink {
                switch $0 {
                case .failure(let error):
                    switch error {
                    case .unauthorized:
                        print("show unauthed alert")
                    default:
                        print("authenticate:", String(describing: error))
                    }
                case .finished: ()
                }
            } receiveValue: {
                self.seasons = $0.filter { $0.hasContent }
            }.store(in: &cancellables)
        }
    }
}
