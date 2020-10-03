//
//  SeasonView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct SeasonView: View {
    @StateObject var state = ViewState()
	var season: RaceSeason
	
    var body: some View {
		List {
            ForEach(state.events.sorted(by: { $0.date() < $1.date() })) {
                EventLink(event: $0)
			}
        }.navigationBarTitle(season.name).onAppear {
            state.load(season)
        }
    }
}

extension SeasonView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var events = [EventResponse]()
        
        var cancellables = [AnyCancellable]()
        
        func load (_ season: RaceSeason) {
            guard events.isEmpty else { return }
            season.events.forEach { path in
                skylark.getEvent(path).receive(on: DispatchQueue.main).sink {
                    switch $0 {
                    case .failure(let error):
                        print("getEvent:", String(describing: error))
                    case .finished: ()
                    }
                } receiveValue: {
                    self.events.append($0)
                }.store(in: &cancellables)
            }
        }
    }
}
