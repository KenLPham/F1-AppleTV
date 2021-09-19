//
//  BannerView.swift
//  F1TV
//
//  Created by Ken Pham on 8/27/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Kingfisher

struct BannerView: View {
    let item: PageContainer

    @ViewBuilder
    var body: some View {
        // gpBanner should only ever have one container
        if let container = item.retrieveItems.resultObject.containers?.first {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    if let countryFlag = container.metadata.attributes?.countryFlag {
                        KFImage(countryFlag)
                            .resizable().aspectRatio(contentMode: .fit).frame(maxWidth: 100, maxHeight: 100)
                    }
                    if let countryName = container.metadata.attributes?.circuitLocation {
                        Text(countryName.uppercased()).bold().font(.title)
                    }
                }
                if let circuitName = container.metadata.attributes?.meetingOfficialName {
                    Text(circuitName.uppercased()).font(.callout)
                }
                if let date = container.metadata.attributes?.meetingDisplayDate {
                    Text(date)
                        .font(.caption2)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 15)
                        .background(Capsule().fill(Color.accentColor))
                }
            }
        }
    }
}
