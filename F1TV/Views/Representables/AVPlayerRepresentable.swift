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
        if #available(tvOS 15.0, *) {
            // use videoPlayer menus for iOS 15
        } else {
            if let overlay = self.overlayView {
                controller.customOverlayViewController = UIHostingController(rootView: overlay())
            }
        }
        
		return controller
	}
	
	func updateUIViewController(_ viewController: AVPlayerViewController, context: Context) {
        player.playImmediately(atRate: 1.0)
        
        if #available(tvOS 15.0, *) {
            viewController.transportBarCustomMenuItems = context.environment.videoPlayer.menus
        }
    }
}

extension AVPlayerControllerRepresentable where OverlayView == Never {
    init (player: AVPlayer) {
        self.player = player
    }
}

// MARK: - Transport Bar Item
class VideoPlayerModifierData: ObservableObject {
    var menus = [UIMenu]()
}

extension VideoPlayerModifierData {
    struct Key: EnvironmentKey {
        static var defaultValue = VideoPlayerModifierData()
    }
}

extension EnvironmentValues {
    var videoPlayer: VideoPlayerModifierData {
        get {
            self[VideoPlayerModifierData.Key.self]
        }
        set {
            self[VideoPlayerModifierData.Key.self] = newValue
        }
    }
}

extension View {
    func viewPlayerMenus (_ menus: [UIMenu]) -> some View {
        self.environment(\.videoPlayer.menus, menus)
    }
}
