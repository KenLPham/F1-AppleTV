//
//  ContentItemView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Kingfisher

struct HorizontalItemView: VideoItemView {
    let item: ContentContainer<String>
    
    var body: some View {
        ContentItemView(item: item, width: 262, height: 147)
    }
}

struct VerticalItemView: VideoItemView {
    let item: ContentContainer<String>
    
    var body: some View {
        ContentItemView(item: item, scale: 1, width: 708, height: 398)
    }
}

struct ContentItemView: View {
    let item: ContentContainer<String>
    
    var scale: CGFloat = 2
    let width: CGFloat
    let height: CGFloat
    
    var scaledWidth: CGFloat {
        width * scale
    }
    var scaledHeight: CGFloat {
        height * scale
    }
    
    var body: some View {
        NavigationLink(destination: Lazy(destination)) {
            VStack(alignment: .leading, spacing: 0) {
                KFImage(item.pictureUrl(width: scaledWidth, height: scaledHeight)).resizable().frame(width: scaledWidth, height: scaledHeight)
                VStack(alignment: .leading) {
                    if let title = item.metadata.title {
                        Text(title).font(.callout)
                    }
//                    Text(item.metadata.contentSubtype.rawValue)
                    Group {
                        switch item.metadata.contentType {
                        case .bundle:
                            HStack {
                                if let date = item.metadata.attributes?.meetingDisplayDate {
                                    Text(date)
                                }
                                Spacer()
                                if let round = item.metadata.attributes?.meetingNumber {
                                    Text("Round \(round)")
                                }
                            }
                        case .video:
                            HStack(spacing: 8) {
                                if let videoDuration = item.metadata.uiDuration {
                                    Text(videoDuration)
                                }
                                Text("|")
                                Text(item.metadata.contentSubtype.rawValue)
                            }
                        case .launcher:
                            EmptyView()
                        }
                    }.font(.caption2).foregroundColor(.secondary)
                }.padding()
            }
        }.buttonStyle(PlainButtonStyle()).frame(width: scaledWidth)
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
