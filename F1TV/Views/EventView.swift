//
//  EventView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct EventView: View {
    @StateObject var state = ViewState()
	var event: EventResponse
	
    var body: some View {
		List {
            ForEach(state.sessions.sorted(by: { $0.startTime < $1.startTime })) { session in
				NavigationLink(destination: Lazy(SessionView(session: session))) {
					Text(session.name)
					if session.isLive {
						Text("Live").font(.subheadline).foregroundColor(Color(.secondaryLabel))
					}
				}
			}
        }.navigationBarTitle(event.officialName).onAppear {
            state.load(event)
        }
    }
}

extension EventView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var sessions = [SessionResponse]()
        
        var cancellables = [AnyCancellable]()
        
        func load (_ event: EventResponse) {
            guard sessions.isEmpty else { return }
            event.sessions.forEach { path in
                skylark.getSession(path).receive(on: DispatchQueue.main).sink {
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
                    guard $0.isF1 else { return } // what a waste of network resources
                    self.sessions.append($0)
                }.store(in: &cancellables)
            }
        }
    }
}
