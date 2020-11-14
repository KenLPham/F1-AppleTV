//
//  AVPlayerRepresentable.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import AVKit
import SwiftUI

struct AVPlayerControllerRepresentable: UIViewControllerRepresentable {
	var player: AVPlayer
	
	func makeUIViewController (context: Context) -> AVPlayerViewController {
		let controller = AVPlayerViewController()
		controller.player = player
		return controller
	}
	
	func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
