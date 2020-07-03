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
	
    var body: some View {
		List {
			Section {
				ForEach(channels.filter({ $0.type != "driver" })) { channel in
					NavigationLink(destination: Lazy(StreamView(channel: channel))) {
						Text(self.parseName(channel))
					}
				}
			}
			Section(header: Text("Driver Feeds")) {
				ForEach(channels.filter({ $0.type == "driver" })) { channel in
					NavigationLink(destination: Lazy(StreamView(channel: channel))) {
						Text(self.parseName(channel))
					}
				}
			}
		}.navigationBarTitle(session.sessionName).onAppear(perform: load)
    }
	
	private func parseName (_ channel: ChannelResponse) -> String {
		switch channel.type {
		case "driver":
			return channel.name
		case "other":
			return channel.name.capitalized
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
