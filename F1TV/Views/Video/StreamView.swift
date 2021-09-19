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
    
    var circuitStreams: [AdditionalStream]? {
        viewModel.channels?.metadata.additionalStreams?.filter { $0.type == .circuit }
    }
    
    var driverStreams: [AdditionalStream]? {
        viewModel.channels?.metadata.additionalStreams?.filter { $0.type == .driver }
    }
    
    @available(tvOS 15.0, *)
    var circuitMenu: UIMenu {
        // - TODO: use the UIAction identifier to figure out which streams are playing
        var options = circuitStreams?.map { stream in
            UIAction(title: stream.title, state: .off) { action in
                viewModel.loadStream(stream)
            }
        } ?? []
        options.append(UIAction(title: "MAIN", state: .off, handler: { action in
            viewModel.load()
        }))
        return UIMenu(options: [ .singleSelection, .displayInline ], children: options)
    }
    
    @available(tvOS 15.0, *)
    var driverMenu: UIMenu {
        let options = driverStreams?.map { stream in
            UIAction(title: stream.title, state: .off) { action in
                viewModel.loadStream(stream)
            }
        } ?? []
        return UIMenu(title: "Drivers", options: [ .singleSelection, .displayInline ], children: options)
    }
    
    // - TODO: this should probably just be the screen size
    let width: CGFloat = 3840
    let height: CGFloat = 2160
	
	// - TODO: figure out how to keep stream time the same when switching between streams (once we get to that)
    var body: some View {
        VStack {
            Group {
                if let player = viewModel.player {
                    if #available(tvOS 15.0, *) {
                        AVPlayerControllerRepresentable(player: player)
                            .viewPlayerMenus([
                                UIMenu(title: "Stream", image: UIImage(systemName: "video"), children: [
                                    circuitMenu, driverMenu
                                ])
                            ])
                    } else {
                        AVPlayerControllerRepresentable(player: player, overlay: Lazy(AdditionalStreamView(viewModel: viewModel)))
                    }
                } else {
                    KFImage(viewModel.content.pictureUrl(width: width, height: height)).resizable().scaledToFill()
                }
            }.ignoresSafeArea()
        }.onAppear(perform: viewModel.load)
    }
}
