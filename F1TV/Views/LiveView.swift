//
//  LiveView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct LiveView: View {
	var live: LiveResponse
	@State var events = [EventResponse]()
	
    var body: some View {
		List {
			ForEach(events.sorted(by: { $0.date() < $1.date() })) { event in
				NavigationLink(destination: Lazy(EventView(event: event))) {
					Text(event.name).bold().font(.title)
					Text(event.officialName).font(.subheadline).foregroundColor(Color(.secondaryLabel))
				}
			}
		}.navigationBarTitle("Race Weekend").onAppear(perform: load)
    }
	
	private func load () {
		guard events.isEmpty else { return }
		guard let event = live.objects.first?.items.first else { return }
		Skylark.shared.getEvent(event.content) { result in
			switch result {
			case .success(let response):
				DispatchQueue.main.async {
					self.events.append(response)
				}
			default: ()
			}
		}
	}
}
