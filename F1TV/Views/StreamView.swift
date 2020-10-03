//
//  StreamView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import AVKit
import SwiftUI
import Combine

struct StreamView: View {
    @StateObject var state = ViewState()
	var channel: ChannelResponse
	
	/// - TODO: figure out how to keep stream time the same when switching between streams (once we get to that)
    var body: some View {
        Group {
            if let player = state.player {
                AVPlayerControllerRepresentable(player: player)
            }
        }.edgesIgnoringSafeArea(.all).onAppear {
            state.load(channel.key)
        }.onDisappear {
            state.player?.pause()
        }
    }
}

extension StreamView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var player: AVPlayer?
        
        var cancellables = [AnyCancellable]()
        
        func load (_ key: String) {
            guard player == nil else {
                player?.play()
                return
            }
            
            skylark.loadStream(from: key).map(\.url).receive(on: DispatchQueue.main).sink {
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
                self.player = AVPlayer(url: $0)
                self.player?.playImmediately(atRate: 1)
            }.store(in: &cancellables)
        }
    }
}
