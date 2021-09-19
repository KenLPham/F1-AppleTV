//
//  AVPlayerRepresentable.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import AVKit
import SwiftUI

struct AVPlayerControllerRepresentable<OverlayView: View>: UIViewControllerRepresentable {
	var player: AVPlayer
    var overlayView: (() -> OverlayView)?
    
    init (player: AVPlayer, overlay: @escaping () -> OverlayView) {
        self.player = player
        self.overlayView = overlay
    }
    
    init (player: AVPlayer, overlay: @autoclosure @escaping () -> OverlayView) {
        self.player = player
        self.overlayView = overlay
    }
	
	func makeUIViewController (context: Context) -> AVPlayerViewController {
		let controller = AVPlayerViewController()
		controller.player = player
        if let overlay = self.overlayView {
            controller.customOverlayViewController = UIHostingController(rootView: overlay())
        }
		return controller
	}
	
	func updateUIViewController(_ viewController: AVPlayerViewController, context: Context) {
        player.playImmediately(atRate: 1.0)
    }
}

extension AVPlayerControllerRepresentable where OverlayView == Never {
    init (player: AVPlayer) {
        self.player = player
    }
}
