//
//  EventView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct EventView: View {
	var event: EventResponse
	@State var sessions = [SessionResponse]()
	
    var body: some View {
		List {
			ForEach(sessions.sorted(by: { $0.startTime < $1.startTime })) { session in
				NavigationLink(destination: Lazy(SessionView(session: session))) {
					Text(session.name)
				}
			}
		}.navigationBarTitle(event.officialName).onAppear(perform: load)
    }
	
	private func load () {
		guard sessions.isEmpty else { return }
		event.sessions.forEach { path in
			Skylark.shared.getSession(path) { result in
				switch result {
				case .success(let response):
					guard response.isF1 else { return } // what a waste of network resources
					DispatchQueue.main.async {
						self.sessions.append(response)
					}
				default: ()
				}
			}
		}
	}
}
