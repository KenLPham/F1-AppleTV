//
//  HeroItemView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Kingfisher

// - TODO: try to make this one class with ContentItemView
struct HeroItemView: VideoItemView {
    let item: ContentContainer<String>

    let scale: CGFloat = 1
    var width: CGFloat {
        1208 * scale
    }
    var height: CGFloat {
        518 * scale
    }
    
    var body: some View {
        NavigationLink(destination: Lazy(destination)) {
            ZStack(alignment: .bottomLeading) {
                KFImage(item.pictureUrl(width: width, height: height)).resizable().frame(width: width, height: height)
                // basically the same layout as ContentItemView except the text colors are hardcoded and a background color is added
                VStack(alignment: .leading) {
                    if let title = item.metadata.title {
                        Text(title).font(.headline)
                    }
                    HStack(spacing: 8) {
                        if let videoDuration = item.metadata.uiDuration {
                            Text(videoDuration)
                        }
                        Text("|")
                        Text(item.metadata.contentSubtype.rawValue)
//                        Text("|")
//                        Text(item.metadata.contentType.rawValue)
                    }.font(.subheadline).foregroundColor(.white.opacity(0.7))
                }.padding().background(Color.black.opacity(0.5))
            }
        }.foregroundColor(.white).buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    var destination: some View {
        switch item.metadata.contentType {
        case .bundle, .launcher:
            if let action = item.actions?.first {
                PageView(viewModel: DetailPageViewModel(action.uri))
            }
        case .video:
            StreamView(viewModel: StreamViewModel(content: item))
        }
    }
}
