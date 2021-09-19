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
import Kingfisher

struct StreamView: View {
    @ObservedObject var viewModel: StreamViewModel
    
    /// - TODO: this should probably just be the screen size
    let width: CGFloat = 3840
    let height: CGFloat = 2160
	
	/// - TODO: figure out how to keep stream time the same when switching between streams (once we get to that)
    var body: some View {
        VStack {
            Group {
                if let player = viewModel.player {
                    AVPlayerControllerRepresentable(player: player, overlay: Lazy(AdditionalStreamView(viewModel: viewModel)))
                } else {
                    KFImage(viewModel.content.pictureUrl(width: width, height: height)).resizable().scaledToFill()
                }
            }.ignoresSafeArea()
        }.onAppear(perform: viewModel.load)
    }
}
