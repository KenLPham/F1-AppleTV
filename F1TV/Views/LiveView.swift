//
//  LiveView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct LiveView: View {
    @StateObject var state = ViewState()
	var live: LiveResponse
    
    var body: some View {
		List {
            ForEach(state.events.sorted(by: { $0.startDate < $1.startDate })) {
				EventLink(event: $0)
			}
        }.navigationBarTitle("Race Weekend").onAppear {
            state.load(live)
        }
    }
}

extension LiveView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var events = [EventResponse]()
        
        var cancellables = [AnyCancellable]()
        
        func load (_ live: LiveResponse) {
            guard events.isEmpty else { return }
            guard let event = live.objects.first?.items.first else { return }
            skylark.getEvent(event.content).receive(on: DispatchQueue.main).sink {
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
                self.events.append($0)
            }.store(in: &cancellables)
        }
    }
}
