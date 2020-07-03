//
//  AVPlayerRepresentable.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import AVKit
import UIKit
import SwiftUI

class PlayerView: UIView {
	private var playerLayer = AVPlayerLayer()
	
	convenience init (_ player: AVPlayer) {
		self.init(frame: .zero)
		
		playerLayer.player = player
		layer.addSublayer(playerLayer)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		playerLayer.frame = self.bounds
	}
}

struct AVPlayerRepresentable: UIViewRepresentable {
	var player: AVPlayer
	
	func makeUIView (context: Context) -> PlayerView {
		PlayerView(player)
	}
	
	func updateUIView (_ view: PlayerView, context: Context) {
	}
}

struct AVPlayerControllerRepresentable: UIViewControllerRepresentable {
	var player: AVPlayer
	
	func makeUIViewController (context: Context) -> AVPlayerViewController {
		let controller = AVPlayerViewController()
		controller.player = player
		return controller
	}
	
	func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
