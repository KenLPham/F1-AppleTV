//
//  VideoContainerView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct VideoContainerView<ItemView: VideoItemView>: View {
    let item: PageContainer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let name = item.metadata.label {
                Text(name).font(.title2)
            }
            if let containers = item.retrieveItems.resultObject.containers {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(containers) {
                            ItemView(item: $0)
                        }
                    }.padding()
                }
            }
        }
    }
}
