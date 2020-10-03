//
//  SessionView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct SessionView: View {
    @StateObject var state = ViewState()
	var session: SessionResponse
	
    var body: some View {
		List {
            if !state.otherChannels.isEmpty {
				Section {
                    ForEach(state.otherChannels) { channel in
						NavigationLink(destination: Lazy(StreamView(channel: channel))) {
							Text(self.parseName(channel))
						}
					}
				}
			}
            if !state.driverChannels.isEmpty {
				Section(header: Text("Driver Feeds")) {
                    ForEach(state.driverChannels) { channel in
						NavigationLink(destination: Lazy(StreamView(channel: channel))) {
							Text(self.parseName(channel))
						}
					}
				}
			}
            if state.driverChannels.isEmpty && state.otherChannels.isEmpty {
				Text("No Channels Available")
			}
        }.navigationBarTitle(session.sessionName).onAppear {
            state.load(session)
        }
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
}

extension SessionView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var channels = [ChannelResponse]()
        
        var otherChannels: [ChannelResponse] {
            channels.filter({ $0.type != "driver" })
        }
        
        var driverChannels: [ChannelResponse] {
            channels.filter({ $0.type == "driver" })
        }
        
        var cancellables = [AnyCancellable]()
        
        func load (_ session: SessionResponse) {
            guard channels.isEmpty else { return }
            session.channels.forEach { path in
                skylark.getChannel(path).receive(on: DispatchQueue.main).sink {
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
                    self.channels.append($0)
                }.store(in: &cancellables)
            }
        }
    }
}
