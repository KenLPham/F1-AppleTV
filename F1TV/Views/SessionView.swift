//
//  SessionView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct SessionView: View {
	var session: SessionResponse
	@State var channels = [ChannelResponse]()
	
	var otherChannels: [ChannelResponse] {
		channels.filter({ $0.type != "driver" })
	}
	
	var driverChannels: [ChannelResponse] {
		channels.filter({ $0.type == "driver" })
	}
	
    var body: some View {
		List {
			if !otherChannels.isEmpty {
				Section {
					ForEach(otherChannels) { channel in
						NavigationLink(destination: Lazy(StreamView(channel: channel))) {
							Text(self.parseName(channel))
						}
					}
				}
			}
			if !driverChannels.isEmpty {
				Section(header: Text("Driver Feeds")) {
					ForEach(driverChannels) { channel in
						NavigationLink(destination: Lazy(StreamView(channel: channel))) {
							Text(self.parseName(channel))
						}
					}
				}
			}
			if driverChannels.isEmpty && otherChannels.isEmpty {
				Text("No Channels Available")
			}
		}.navigationBarTitle(session.sessionName).onAppear(perform: load)
    }
	
	private func parseName (_ channel: ChannelResponse) -> String {
		switch channel.type {
		case "driver":
			return channel.name
		case "other":
			return channel.name == "driver" ? "Tracker" : channel.name.capitalized
		default:
			return "Main Feed"
		}
	}
	
	private func load () {
		guard channels.isEmpty else { return }
		session.channels.forEach { path in
			Skylark.shared.getChannel(path) { result in
				switch result {
				case .success(let response):
					DispatchQueue.main.async {
						self.channels.append(response)
					}
				default: ()
				}
			}
		}
	}
}
