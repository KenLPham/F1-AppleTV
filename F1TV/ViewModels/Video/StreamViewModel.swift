//
//  StreamViewModel.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import AVFoundation
import AVKit
import SwiftUI
import Combine
import Kingfisher
import os.log

class StreamViewModel: ObservableObject {
    @Environment(\.apiClient) var apiClient
    @Published var channels: ContentContainer<Int>?
    
    @Published var playback: PlaybackResultObject? {
        didSet {
            self.generatePlayer()
        }
    }
    @Published var player: AVPlayer?
    
    let content: ContentContainer<String>
    
    private var cancellables = [AnyCancellable]()
    
    init (content: ContentContainer<String>) {
        UIApplication.shared.isIdleTimerDisabled = true
        self.content = content
    }
    
    func load () {
        apiClient.getPlaybackUrl(content.id).receive(on: DispatchQueue.main).sink {
            switch $0 {
            case .failure(let error):
                Logger.apiClient.error("\(String(describing: error))")
            default: ()
            }
        } receiveValue: {
            self.playback = $0
        }.store(in: &cancellables)
        
        if self.channels == nil {
            self.loadStreams()
        }
    }
    
    func loadStream (_ stream: AdditionalStream) {
        apiClient.getPerspectivePlaybackUrl(stream.playbackUrl).receive(on: DispatchQueue.main).sink {
            switch $0 {
            case .failure(let error):
                Logger.apiClient.error("\(String(describing: error))")
            default: ()
            }
        } receiveValue: {
            self.playback = $0
        }.store(in: &cancellables)
    }
    
    private func loadStreams () {
        if content.isRace {
            apiClient.getDetailContainers(content.id).receive(on: DispatchQueue.main).sink {
                switch $0 {
                case .failure(let error):
                    Logger.apiClient.error("\(String(describing: error))")
                default: ()
                }
            } receiveValue: {
                guard let container = $0 else {
                    return Logger.apiClient.fault("Content \(self.content.id) has no details")
                }
                self.channels = container
            }.store(in: &cancellables)
        }
    }
    
    private func generatePlayer () {
        guard let playbackUrl = playback?.url else { return }
        let asset = AVURLAsset(url: playbackUrl)
        let item = AVPlayerItem(asset: asset)
        
        // - TODO: figure out why the cfx channel is the only one that doesn't use the title...
        // set default audio channel to english (original default is FX)
        if let audioGroup = asset.mediaSelectionGroup(forMediaCharacteristic: .audible) {
            item.select(AVMediaSelectionGroup.mediaSelectionOptions(from: audioGroup.options, with: Locale(identifier: "eng")).first, in: audioGroup)
        }
        
        /// - NOTE: Player Info that shows up on iPhone
        item.externalMetadata = [
            self.createMetadata(.commonIdentifierTitle, value: content.metadata.title),
            self.createMetadata(.quickTimeMetadataGenre, value: content.metadata.genres.first)
        ]
        
        // setup metadata thumbnail
        if let url = content.pictureUrl(width: 1280, height: 720) {
            let resource = ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let image):
                    item.externalMetadata.append(self.createMetadata(.commonIdentifierArtwork, value: image.image.pngData()))
                case .failure(let error):
                    Logger.image.error("\(String(describing: error))")
                }
            }
        }
        
        // handle switching or initializing new stream
        if let player = self.player {
            player.pause()
            item.seek(to: player.currentTime()) { _ in
                player.replaceCurrentItem(with: item)
                // - TODO: this seems to be necessary on tvOS 15, make sure switching still works on tvOS 14 without this
                if #available(tvOS 15.0, *) {
                    player.playImmediately(atRate: 1.0)                    
                }
            }
        } else {
            self.player = AVPlayer(playerItem: item)
        }
    }
    
    private func createMetadata (_ type: AVMetadataIdentifier, value: String?) -> AVMetadataItem {
        let metadata = AVMutableMetadataItem()
        metadata.identifier = type
        metadata.value = value as NSString?
        return metadata
    }
    
    private func createMetadata (_ type: AVMetadataIdentifier, value: Data?) -> AVMetadataItem {
        let metadata = AVMutableMetadataItem()
        metadata.identifier = type
        metadata.value = value as NSData?
        return metadata
    }
    
    deinit {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
